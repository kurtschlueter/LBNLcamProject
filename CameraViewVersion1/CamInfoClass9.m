classdef  CamInfoClass9 < handle

    
    properties (SetAccess = public)

        hFig;
        devicepanel;
        deviceLabel;
        deviceTbox;

        view1panel;
        view2panel;

        view1axis;
        view2axis;
        
        cameras;
        viewOption;
        
        vid = [];


    end
    

    methods
        function this = CamInfoClass9()  
         
            
            this.vid{30} = 1; %I had to set a dimension. 30 has to be larger than # of cams

            %FIGURE
            hFig=figure('Position',[100,50,1280,780],...
                        'Resize','off','Color',[0.78,0.86,1.0]);


            % DEVICES Panel 
            this.devicepanel = uipanel('Title','Devices','BackgroundColor','white',...
                                        'Position',[.02 .39 .28 .58]);    

                % Titles at top of device panel   
                this.deviceTbox = uicontrol('Parent',this.devicepanel, ...
                           'Style', 'text', 'String', ...
                           ' Camera    Power      View        Rec     Schedule', ...
                           'HorizontalAlignment', 'left', 'FontSize', 11.5, ...
                           'Position', [8 400 340 28], 'BackgroundColor',[0.4863 0.72 0.8]);
                       

            %VIEW 1 image streaming panel
            this.view1panel = uipanel('Title','VIEW1','BackgroundColor',...
                                      [.8 .8 .8],...
                                      'Position',[.52 .52 .45 .45]); 

                %Axis in panel 1
                this.view1axis = axes('Parent',this.view1panel);
                                        hold on;
                                        axis off; 
                                        hold off;


            %VIEW 2 image streaming panel
            this.view2panel =uipanel('Title','VIEW2','BackgroundColor',[.8 .8 .8],... 
                                     'Position',[.52 0.02 .45 .45]);

                %Axis in panel 2
                this.view2axis = axes('Parent',this.view2panel);
                                        hold on;
                                        axis off; 
                                        hold off; 
                                        
            %Instances of each camera in the device panel                       
            %devicepanel, camNum, camName, camOption, camPower, maqAdaptorName, imaqDeviceID, imaqFormat
            this.cameras{1} = IndividualCamClass4(this.devicepanel, 1, 'Camera 1', 3, 1, 'gige', 1, 'Mono8');
            this.cameras{2} = IndividualCamClass4(this.devicepanel, 2, 'Camera 2', 3, 1, 'gige', 2, 'Mono8');
            this.cameras{3} = IndividualCamClass4(this.devicepanel, 3, 'Camera 3', 3, 1, 'cam3PH', 3, 'cam3PH');

            addlistener(this.cameras{1}, 'changeView', @this.handleChangeView); 
            addlistener(this.cameras{1}, 'changePower', @this.handleChangePower); 
            
            addlistener(this.cameras{2}, 'changeView', @this.handleChangeView);
            addlistener(this.cameras{2}, 'changePower', @this.handleChangePower); 
            
            addlistener(this.cameras{3}, 'changeView', @this.handleChangeView);
            addlistener(this.cameras{3}, 'changePower', @this.handleChangePower); 
            
             this.viewOption{1} = ViewOptionsClass4(hFig, 1, 0);
             this.viewOption{2} = ViewOptionsClass4(hFig, 2, 0);
             
            addlistener(this.viewOption{1}, 'captureFrame', @this.handleCaptureFrame);
            addlistener(this.viewOption{2}, 'captureFrame', @this.handleCaptureFrame);
            
            addlistener(this.viewOption{1}, 'captureSeries', @this.handleCaptureSeries);
            addlistener(this.viewOption{2}, 'captureSeries', @this.handleCaptureSeries);

        end
        
        function handleChangeView(this, src, evt)

           disp('CamInfoClass7.handleChangeView()'); 
           disp(src)
           %If view 1 or 2 was selected
           if src.camOptionX == 1 || src.camOptionX == 2 
               disp('scr.camOptionX should be 1 or 2');
               for xx = 1:3
                  %if selected camera (this.cameras)is the same as camera being checked in the for loop (src)
                  if xx == src.camNumX
                        %Automatic turn on if view is selected and cam is off

                        if src.camPowerX == 0
                            disp('same cam in for loop, power off');
                            set(src.camPowerMode,'Value',1);
                            src.camPowerX = 1; 
                            this.powerLightGenerator(src.powerAxis, 1);
                            
                        else
                              disp('same cam in for loop, power on');
                        end
                        
                   %If selected camera (old cam=this.cameras) is not the same as camera being checked in the for loop (new cam=src) and both are on the same view     
                   elseif this.cameras{xx}.camOptionX == src.camOptionX
                      
                        disp('a certain cam does have the wanted view');
                        %this sets the viewing option to 'None' = 3 in the GUI
                        set(this.cameras{xx}.camViewMode,'Value',3);
                        %this sets the viewing option to 'None' = 3 for the old cam (this.cameras) (FOR cameras(x) instance variable) 
                        this.cameras{xx}.camOptionX = 3; 
                        this.cameras{xx}.previousCamOptionX = 3;
                        %stop the imaq preview on the old cam (this.cameras)to make way to start the preview for the new cam (src)
                        this.imaqViewTrigger(this.cameras{xx}.camNumX, 3, this.cameras{xx}.imaqAdaptorNameX, this.cameras{xx}.imaqDeviceIDX, this.cameras{xx}.imaqFormatX);

                        this.recordLightGenerator(this.cameras{xx}.recordAxis, this.cameras{xx}.camOptionX);
                   end
               end

               %Identifies that cam was on previous view so it shuts down
               %old view option panel before it can open a new one
               if src.previousCamOptionX ~= 3
                   set(this.viewOption{src.previousCamOptionX}.view1optionsPanel,'Visible','off');
                   this.viewOption{src.previousCamOptionX}.cameraNumberX = 0;
               end
               
               %Pops up video option panel for specified view
               set(this.viewOption{src.camOptionX}.view1optionsPanel,'Visible','on');
               %Puts the name of the camera being viewd in the title
               set(this.viewOption{src.camOptionX}.view1CurrentCamLabelTbox,'String',src.camNameX);
               this.viewOption{src.camOptionX}.cameraNumberX = src.camNumX;
               
               disp('actual turn on preview');
               this.imaqViewTrigger(src.camNumX, src.camOptionX, src.imaqAdaptorNameX, src.imaqDeviceIDX, src.imaqFormatX);
               this.recordLightGenerator(src.recordAxis, src.camOptionX);
           
           %If view 'None' was selected
           else 
                set(this.viewOption{src.previousCamOptionX}.view1optionsPanel,'Visible','off');
                this.viewOption{src.previousCamOptionX}.cameraNumberX = 0;
                disp('scr.camOptionX should be 3');
                this.imaqViewTrigger(src.camNumX, 3, src.imaqAdaptorNameX, src.imaqDeviceIDX, src.imaqFormatX);
                this.recordLightGenerator(src.recordAxis, src.camOptionX);
               
           end

         
         src.previousCamOptionX = src.camOptionX;  
         disp(src);
        end
        
        function handleChangePower(this, src, evt)
            
           disp('CamInfoClass7.handleChangePower()'); 

           if src.camPowerX == 1
                this.powerLightGenerator(src.powerAxis, 1);
                this.imaqPowerTrigger(src.camNumX, 1, src.imaqAdaptorNameX, src.imaqDeviceIDX, src.imaqFormatX);  
           else
                this.imaqViewTrigger(src.camNumX, 3, src.imaqAdaptorNameX, src.imaqDeviceIDX, src.imaqFormatX);
                this.imaqPowerTrigger(src.camNumX, 0, src.imaqAdaptorNameX, src.imaqDeviceIDX, src.imaqFormatX);
                this.powerLightGenerator(src.powerAxis, 0);
                this.recordLightGenerator(src.recordAxis, 0);
                set(src.camViewMode,'Value',3);
                src.camOptionX = 3; 
           end
           disp(src)

        end
        
        function handleCaptureFrame(this, src, evt)
            
            disp(src)
            
            specificSaveCheckBoxSnapshot = get(src.specificSaveCheckBoxSnapshot,'Value');
            genericSaveCheckBoxSnapshot = get(src.saveCheckBoxSnapshot,'Value');
            previewCheckBoxSnapshot = get(src.previewCheckBoxSnapshot,'Value');
            
            %Gets the current time and current day
            currentClockFull = clock;
            currentDay = datestr(currentClockFull, 1);
            currentTimeIso = datestr(currentClockFull, 'HH_MM_SS');
            
            %This either creates a new folder or identifies a an exsisting folder 
            %with regards to what day it is
            currentDayDirectory = strcat('C:\Users\metmatlab\Documents\MATLAB\MirrorImages\',currentDay);
            if exist(currentDayDirectory, 'dir') == 0
                    mkdir('C:\Users\metmatlab\Documents\MATLAB\MirrorImages',currentDay);
            end
            
            % if neither preview nor generic save nor specific save was selected
            if genericSaveCheckBoxSnapshot == 0 && previewCheckBoxSnapshot == 0
                set(src.messageBoardText, 'ForegroundColor', 'red');
                set(src.messageBoardText, 'String', ...
                'Neither the preview nor save options were selected. Please select an option first');
            
            %Preview or specific save or generic save was selected
            elseif genericSaveCheckBoxSnapshot == 1 || previewCheckBoxSnapshot == 1
                disp('goes in generic save and preview');
                %get snapshot of image
                img = getsnapshot(this.vid{src.cameraNumberX});
                
                % we want to save
                if genericSaveCheckBoxSnapshot == 1
                        disp('goes in save only');
                        % if generic save and specific save were selected
                        if genericSaveCheckBoxSnapshot == 1 && specificSaveCheckBoxSnapshot == 1
                                disp('goes int specific save');
                                specificFolder = get(src.specificSaveEditBoxSnapshot, 'String');
                                currentFinalDirectory = strcat(currentDayDirectory,'\',specificFolder);
                                disp(currentFinalDirectory)
                                exist(currentFinalDirectory, 'dir')
                                if exist(currentFinalDirectory, 'dir') == 0
                                        mkdir(currentDayDirectory,specificFolder);
                                end

                        %if  only generic save was selected
                        elseif genericSaveCheckBoxSnapshot == 1 && specificSaveCheckBoxSnapshot == 0
                                disp('goes int generic save only');
                                currentFinalDirectory = currentDayDirectory; 

                        end


                        fileName = strcat(currentFinalDirectory,'\camera',num2str(src.cameraNumberX),'_', currentTimeIso);
                        imwrite(img,fileName,'jpg');

                        mesCat = strcat('Image saved to', {' '},currentFinalDirectory);    
                        set(src.messageBoardText, 'ForegroundColor', [0 .6 0]);
                        set(src.messageBoardText, 'String', mesCat);
                end
                
                %We want to preview 
                if previewCheckBoxSnapshot == 1
                    disp('goes into preview');
                    figureName =  strcat('camera',num2str(src.cameraNumberX),'_', currentDay, '_',currentTimeIso);
                    figure('Name',figureName);
                    image(img);
                    colormap(gray);
                end
                
            end
            
        end
        
        function handleCaptureSeries(this, src, evt)
            
            
            disp(src)
            
            specificSaveCheckBoxBurst = get(src.specificSaveCheckBoxBurst,'Value');
            genericSaveCheckBoxBurst = get(src.saveCheckBoxBurst,'Value');
            previewCheckBoxBurst = get(src.previewCheckBoxBurst,'Value');
            totalSnapshots = str2num(get(src.captureSeriesFrameNumberEditBurst, 'String'));
            totalTime = str2num(get(src.captureSeriesTimeNumberEditBurst, 'String'));
            


            
            % if neither preview nor generic save nor specific save was selected
            if genericSaveCheckBoxBurst == 0 && previewCheckBoxBurst == 0
                set(src.messageBoardText, 'ForegroundColor', 'red');
                set(src.messageBoardText, 'String', ...
                'Neither the preview nor save options were selected. Please select an option first');
            
            %elseif frames is not a number
            
            %elseif combo is not divisble to 1 frame per integer time second
            
            %Preview or specific save or generic save was selected
            elseif genericSaveCheckBoxBurst == 1 || previewCheckBoxBurst == 1
                disp('goes in generic save and preview');
                %get snapshot of image
                
                
                for snapshotNumber = 1:totalSnapshots
                
                    %Gets the current time and current day again
                    currentClockFull = clock;
                    currentDay = datestr(currentClockFull, 1);
                    currentTimeIso = datestr(currentClockFull, 'HH_MM_SS');
                    
                    
                    %This either creates a new folder or identifies a an exsisting folder 
                    %with regards to what day it is
                    currentDayDirectory = strcat('C:\Users\metmatlab\Documents\MATLAB\MirrorImages\',currentDay);
                    if exist(currentDayDirectory, 'dir') == 0
                            mkdir('C:\Users\metmatlab\Documents\MATLAB\MirrorImages',currentDay);
                    end
                    
%                     localTimer = timer('StartDelay',totalTime/totalSnapshots);
%                     localTimer.TimerFcn = @(myTimerObj, thisEvent)disp(snapshotNum);
%                     start(localTimer);
                    
                    img = getsnapshot(this.vid{src.cameraNumberX});

                    % we want to save
                    if genericSaveCheckBoxBurst == 1
                            disp('goes in save only');
                            % if generic save and specific save were selected
                            if genericSaveCheckBoxBurst == 1 && specificSaveCheckBoxBurst == 1
                                    disp('goes int specific save');
                                    specificFolder = get(src.specificSaveEditBoxBurst, 'String');
                                    currentFinalDirectory = strcat(currentDayDirectory,'\',specificFolder);
                                    disp(currentFinalDirectory)
                                    exist(currentFinalDirectory, 'dir')
                                    if exist(currentFinalDirectory, 'dir') == 0
                                            mkdir(currentDayDirectory,specificFolder);
                                    end

                            %if  only generic save was selected
                            elseif genericSaveCheckBoxBurst == 1 && specificSaveCheckBoxBurst == 0
                                    disp('goes int generic save only');
                                    currentFinalDirectory = currentDayDirectory; 

                            end


                            fileName = strcat(currentFinalDirectory,'\camera',num2str(src.cameraNumberX),'_', currentTimeIso);
                            imwrite(img,fileName,'jpg');

                            mesCat = strcat('Image saved to', {' '},currentFinalDirectory);    
                            set(src.messageBoardText, 'ForegroundColor', [0 .6 0]);
                            set(src.messageBoardText, 'String', mesCat);
                    end
                

                
                    %We want to preview 
                    if previewCheckBoxBurst == 1
                        disp('goes into preview');
                        figureName =  strcat('camera',num2str(src.cameraNumberX),'_', currentDay, '_',currentTimeIso);
                        figure('Name',figureName);
                        image(img);
                        colormap(gray);
                    end
                    
                      pause(totalTime/totalSnapshots);
%                     delete(localTimer);
                 end
            end
            
            
        end
        
        %This function just sets the power indicator to red or green for
        %each camera
        function powerLightGenerator(this, currentAxis, currentPower)

            axes(currentAxis);
            gca

            xc = 3.0;
            yc = 1.0;
            r = 0.21;
            x = r*sin(-pi:0.1*pi:pi) + xc;
            y = r*cos(-pi:0.1*pi:pi) + yc;
            
           if currentPower == 1
                fill(x, y, 'g')
           else
                fill(x, y, 'r')
           end
           axis off
            
        end
        

        
        %This function just sets the recording indicator to red or green for
        %each camera
        function recordLightGenerator(this, currentAxis, currentView)

            axes(currentAxis);
            gca

            xc = 3.0;
            yc = 1.0;
            r = 0.21;
            x = r*sin(-pi:0.1*pi:pi) + xc;
            y = r*cos(-pi:0.1*pi:pi) + yc;
            
           if currentView == 1
                fill(x, y, 'g')
           elseif currentView == 2
                fill(x, y, 'g') 
           else
                fill(x, y, 'r')
           end
           axis off
            
        end        
        
        %This function turns the selected camera online. This is basically
        %plugin and plugout. Cant do this until that specific hardware is
        %installed
        function imaqPowerTrigger(this, camNum, currentPower, imaqAdaptorName, imaqDeviceID, imaqFormat)


        end
        
        %This function turn the camera to a specific view. Its streaming on
        %an axis somewhere. Not recording or snapshot. just for view
        function imaqViewTrigger(this, camNum, currentView, imaqAdaptorName, imaqDeviceID, imaqFormat)
           
           %this creates a new videoinput everytime 
           if isempty(this.vid{camNum}) == 0 
                delete(this.vid{camNum});
           end
           this.vid{camNum} = videoinput(imaqAdaptorName, imaqDeviceID, imaqFormat); %adaptorName, deviceID, format
           
           if currentView == 1
                res = get(this.vid{camNum}, 'VideoResolution'); 
                bands = get(this.vid{camNum}, 'NumberOfBands');
                
               viewStream = image(...
                      zeros(res(2), res(1), bands), ...
                      'Parent', this.view1axis ...
                );
                
                preview(this.vid{camNum}, viewStream);
                
           elseif currentView == 2
                res = get(this.vid{camNum}, 'VideoResolution'); 
                bands = get(this.vid{camNum}, 'NumberOfBands');
                
               viewStream = image(...
                      zeros(res(2), res(1), bands), ...
                      'Parent', this.view2axis ...
                );
                
                preview(this.vid{camNum}, viewStream);
           else
               disp('imaqViewTrigger stop preview');
                stoppreview(this.vid{camNum});
           end

        end
        
    end
end