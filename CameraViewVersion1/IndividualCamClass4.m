

classdef  IndividualCamClass4 < handle

    
    properties (SetAccess = public)

        devicepanel;

        camNumX; %what camera number we are on (integer)
        camNameX; %camera name (string)
        camOptionX; % camera view 1, 2, or none
        camPowerX; % power of camera
        deviceLabel;
        deviceTbox;
        deviceTest1;
        devicePowerPanel;
        camNameControl;
        testPanel;
        camViewMode; %switch for view 1 view 2 or none
        camPowerMode; %toggle for power on or power off
        powerAxis; %axis for power color indicatpor
        recordAxis; %axis for recording color indicator
        
        %These three are the id's for the actual cameras
        imaqAdaptorNameX;
        imaqDeviceIDX;
        imaqFormatX;
        
        previousCamOptionX = 3; 

    end
    
    events
        changeView;
        changePower;
    end

    methods
        function this = IndividualCamClass4(devicepanel,camNum,camName,camOption,camPower, imaqAdaptorName, imaqDeviceID, imaqFormat)
            
            this.camNumX = camNum;
            this.camNameX = camName;
            this.camOptionX = camOption;
            this.camPowerX = camPower;
            this.imaqAdaptorNameX = imaqAdaptorName;
            this.imaqDeviceIDX = imaqDeviceID; 
            this.imaqFormatX = imaqFormat;


            stepPos = .9 - (.1*camNum); % This is the the virtical position of each camera tab. 
                                        % The first registered cam will be at position .8.
                                        % The second registered cam will be at
                                        % position .7. etc...

            % this creates each camera uipanel.      
            this.deviceTest1 = uipanel('Parent',devicepanel, ...
                                       'BackgroundColor',[.628 .628 .628],...
                                       'Position', [.02 stepPos .96 .1]);

            %Camera name in the respective uipanel                      
            this.camNameControl = uicontrol('Parent',this.deviceTest1, ...
                                        'Style', 'text', 'String', ...
                                        camName, ...
                                        'HorizontalAlignment', 'left', ...    
                                        'FontSize', 10, ...
                                        'Position', [3 1 60 30], ...
                                        'BackgroundColor',[.628 .628 .628]);   
                                    


              % The drop down view menu                                   
              this.camViewMode = uicontrol('Parent', this.deviceTest1, 'Style', 'popup',...
                           'String', 'View1|View2|None','Value',camOption,...
                           'Position', [130 1 60 30], 'Callback', @this.optionView_cb);
              
              %The panel that houses the power green red circle and radiobutton. Just for aesthetic purposes really         
              this.devicePowerPanel = uipanel('Parent',this.deviceTest1, ...
                           'BackgroundColor',[0.4863 0.72 0.8],...
                           'Position', [.21 .05 .16 .9], ...
                           'BorderType', 'none');   
                       
              % The Power radio button                                 
              this.camPowerMode = uicontrol('Parent', this.devicePowerPanel, 'Style', 'radiobutton',...
                           'Value',camPower, 'Position', [29 6.5 25 25],...
                           'Callback', @this.optionPower_cb, 'BackgroundColor',[0.4863 0.72 0.8]);

             %Green or Red circle indicating Power (initial Set Up)
             %Right now I have it set up so that the program starts with
             %all the cameras off.
             this.powerAxis = axes('Parent',this.devicePowerPanel, 'Position', ...
                   [.05 .24 .42 .5] );

                    axes(this.powerAxis);
                    gca

                    xc = 3.0;
                    yc = 1.0;
                    r = 0.21;
                    x = r*sin(-pi:0.1*pi:pi) + xc;
                    y = r*cos(-pi:0.1*pi:pi) + yc;

                    if this.camPowerX == 1 
                        fill(x, y, 'g')
                    else
                        fill(x, y, 'r')
                    end
                    axis off
                    
             %Green or Red circle indicating cam is recording (initial Set Up)
             %Right now I have it set up so that the program starts with
             %all the cameras off.. so also not recording
             this.recordAxis = axes('Parent',this.deviceTest1, 'Position', ...
                   [.64 .27 .08 .5] );

                    axes(this.recordAxis);
                    gca

                    xc = 3.0;
                    yc = 1.0;
                    r = 0.21;
                    x = r*sin(-pi:0.1*pi:pi) + xc;
                    y = r*cos(-pi:0.1*pi:pi) + yc;
                    
                    %change in future if needed.
                    if this.camOptionX == 1  
                        fill(x, y, 'g')
                    elseif this.camOptionX == 2  
                        fill(x, y, 'g')
                    else
                        fill(x, y, 'r')
                    end
                    axis off


        end
        
        %Callback for View dropdown Menu
        function optionView_cb(this,~,~)
            this.camOptionX = get(this.camViewMode,'Value');
            notify(this, 'changeView');
        end
        
        %Callback for Power toggle button
        function optionPower_cb(this,~,~)
            this.camPowerX = get(this.camPowerMode,'Value');
            notify(this, 'changePower');
        end

    end
end