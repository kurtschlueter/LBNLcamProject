
%CALCULATEPACKETDELAY Calculates packet delay for the GigE camera.
%
%    DELAY = CALCULATEPACKETDELAY(OBJ, framesPerSecond)
%
%    DELAY = CALCULATEPACKETDELAY(OBJ) where OBJ is an image acquisition
%    object, returns a numeric value, DELAY, which is the delay between
%    packets.
%
%    To create an image acquisition object use the IMAQHELP function:
%
%    imaqhelp videoinput
%
%    Example:
%       % Construct a video input object for GigE device. 
%       obj = videoinput('gige', 1);
%
%       % View the properties for the selected video source object.
%       src_obj = getselectedsource(obj);
%       get(src_obj)
%
%       % Set the desired acquisition parameters.
%       src_obj.FrameRate = 4;
%       src_obj.PacketSize = 1514;
%       obj.RoiPosition=[0 0 48 50];
%
%       % Calculate the packet delay.
%       delay = CalculatePacketDelay(obj, 10);
%
%    See also DELETE, IMAQHWINFO, IMAQFIND, IMAQDEVICE/ISVALID,
%    IMAQDEVICE/PREVIEW

%   Copyright 2013 The MathWorks, Inc. $Date: 2013/12/24  $

function [delay] = CalculatePacketDelay(vid, framesPerSecond)

    if nargin < 2
        error('CalculatePacketDelay(vid, framesPerSecond) videoinput object and framerate are required arguments to run this utility.');
    else
        if ~isnumeric(framesPerSecond)
            error('CalculatePacketDelay(vid, framesPerSecond) framesPerSecond must be a number');
        end
    end

    if ~isa(vid, 'videoinput') || ~isvalid(vid)
        error('CalculatePacketDelay(vid, framesPerSecond) vid must be a valid videoinput object');
    else
        a=imaqhwinfo(vid);
        if ~strcmp(a.AdaptorName,'gige')
            error('The videoinput object must use a gige device');
        end
    end
    
    src = getselectedsource(vid);
    
    % get packet size (depending on MATLAB release PacketSize is int32 or char)
    if isnumeric(src.PacketSize)
        packetSize = double(src.PacketSize);
    else
        packetSize = str2double(src.PacketSize);
    end
    
try
    TickFreq = src.TimestampTickFrequency;
catch e
    if strcmp(e.identifier,'MATLAB:noSuchMethodOrField') || strcmp(e.identifier,'testmeas:getset:invalidProperty')
         error('Packet delay is not supported on the device');
    end
end


videoFormat=vid.videoFormat;

switch (videoFormat)
    case {'Mono8' ,'BayerGR8','BayerRG8','BayerGB8','BayerBG8'}
        BytesPerPixel = 1;
    case {'Mono10Packed' ,'YUV411Packed'}
        BytesPerPixel = 1.5;
    case {'Mono10','Mono12','Mono14' ,'Mono16','BayerGR10','BayerRG10','BayerGB10','BayerBG10','BayerGR12','BayerRG12','BayerGB12','BayerBG12','BayerGR16','BayerRG16','BayerGB16','BayerBG16','YUV422Packed',''}
        BytesPerPixel =2;
    case {'RGB8Packed','BGR8Packed','YUV444Packed','RGB8Planar',}
        BytesPerPixel=3;
    case {'RGBA8Packed','BGRA8Packed'}
        BytesPerPixel = 4;
    case {'RGB10Packed','BGR10Packed','RGB12Packed','BGR12Packed','RGB10Planar','RGB12Planar','RGB16Planar'}
        BytesPerPixel = 6;
end

roi = vid.ROIPosition;
height = roi(1,3);
width = roi(1,4);

fprintf('Calculating Packet Delay for:\n FrameRate = %d,\tPacketSize = %d,\tFrameHeight = %d,\tFrameWidth = %d,\tVideoFormat = %s\n',framesPerSecond,packetSize,height,width,videoFormat);

numOfBytes_EthernetHeader = 14;
numOfBytes_IPHeader  = 20;
numOfBytes_UDPHeader = 8;
numOfBytes_GVSPHeader = 8;
numOfBytes_EthernetFooter = 2;


numOfBytes_overheadPerPacket = numOfBytes_EthernetHeader+numOfBytes_IPHeader+numOfBytes_UDPHeader+numOfBytes_GVSPHeader;
numOfBytes_GVSP_Leader = numOfBytes_overheadPerPacket+36;
numOfBytes_GVSP_Trailer = numOfBytes_overheadPerPacket+numOfBytes_EthernetFooter+numOfBytes_GVSPHeader; %Ethernet Footer+GVSP Header

actual_packetSize = packetSize-numOfBytes_overheadPerPacket;

numOfBytes_perFrame = height  *  width  *  BytesPerPixel;

numOfPackets_perFrame = ceil(numOfBytes_perFrame/actual_packetSize)+2 ; 

total_OverHead_Bytes = ceil(numOfPackets_perFrame) * numOfBytes_overheadPerPacket;

full_packets = floor(numOfPackets_perFrame ) * actual_packetSize;

numOfBytes_perImage = numOfBytes_GVSP_Leader+(floor(numOfPackets_perFrame ) * actual_packetSize)+(numOfBytes_perFrame-(full_packets))+total_OverHead_Bytes + numOfBytes_GVSP_Trailer;

numOfBytes_perSec  = framesPerSecond * numOfBytes_perImage;

bits_perSecond = numOfBytes_perSec  * 8;

ratio_GigeUtilized= bits_perSecond/10^9;

ratio_GigeNotUtilized = 1 - ratio_GigeUtilized;

pauseTime_between_Packets = ratio_GigeNotUtilized/(numOfPackets_perFrame * framesPerSecond)

PacketDelay = TickFreq * pauseTime_between_Packets;

delay = 0.9 * PacketDelay;

fprintf(1, 'Time stamp tick frequency (ticks/s): %.1f \n', TickFreq);
fprintf(1, 'Used gigabit bandwitdh: %.1f %%\n', 100*ratio_GigeUtilized);
fprintf(1, 'Packet Delay: %.1f (ticks)\n',delay);


end
