classdef patchBuilderDaySchedule3 < handle

    properties (SetAccess = public)
        
        specialToolsInstance;
        
        dayPanelWithDataHolder;
        dayAxisWithData;
        hHggroup;
        hSliderYPan;
        
        dYPan;
        
        dateID;
        secondUsageSlot;
        
        maxPatchPos;
        minPatchPos;
        minTime;
        maxTime;
        mSlope;
        patchRange;
        thick;
        stepSize;
        
        patchTemp;
        
        camClickedStruct;
        
    end
    
    events
        specificEventClicked;
    end
    
    methods
        function this = patchBuilderDaySchedule3(motherPanel,dateID) 
            
            % Instance of StructDateTimeTools1
            this.specialToolsInstance = StructDateTimeTools1;
            
            this.dateID = dateID;
            
            heightAxis = 436;
            widthAxis = 667;
            
            %Relationship between patch position and time math work;
            this.maxPatchPos = 1.96;
            this.minPatchPos = -2.96;
            this.minTime = 0;
            this.maxTime = 86399;
            this.mSlope = (this.maxPatchPos - this.minPatchPos)/(this.minTime-this.maxTime);
            %y = mSlope * x + (minPatchPos - mSlope * maxTime);
            
            this.patchRange = abs(this.maxPatchPos) + abs(this.minPatchPos);
            this.thick = this.patchRange/2150;
            this.stepSize = this.patchRange/12; 
            

            this.dayPanelWithDataHolder = uipanel('Parent', motherPanel,...
                          'BackgroundColor',[.75 .65 .95],...
                          'Units', 'pixels',...
                          'Position', [1 1 widthAxis heightAxis],...
                          'Clipping', 'on');    

            this.dayAxisWithData = axes('Parent', this.dayPanelWithDataHolder,...
                           'Color',[1 1 1],...
                           'XTickLabel','',...
                           'YTickLabel','',...
                           'XTick', [],...
                           'YTick', [],...
                           'XColor', [1 1 1],...
                           'YColor', [1 1 1],...
                           'Units', 'pixels',...
                           'Position', [0 0 widthAxis heightAxis],...
                           'XLim', [-1 1], ...
                           'YLim', [1 2], ...
                           'Clipping', 'on');

            this.hHggroup = hggroup ('Parent', this.dayAxisWithData,...
                           'Clipping', 'on'); 

            this.hSliderYPan = uicontrol(...
                    'Parent', this.dayPanelWithDataHolder,...
                    'Style', 'slider', ...
                    'Min', -2, ...
                    'Max',2, ...
                    'Value', 2, ...
                    'SliderStep', [.02 .1],...
                    'Position', ...
                        [widthAxis - 21 ...
                        0 ...
                        20 ...
                        heightAxis - 3 ]);
    
            lh3 = addlistener(this.hSliderYPan, 'ContinuousValueChange', @this.handleSliderYPan);
            this.setUpPatchWork;
            this.specialPatchWorkFull(this.dateID);
  
        end
        
        function handleSliderYPan(this, ~, ~)

            dVal = get(this.hSliderYPan, 'Value');

            dLimits = get(this.dayAxisWithData, 'Ylim');

            dRange = 1;
            
            if dVal > 0
                dLimMin = dVal - dRange;
                dLimMax = dVal;
            %     set(this.dayAxisWithData, 'Ylim', [(dVal - dRange/2) dVal]);
            end

            if dVal < 0
                dLimMin = dVal - dRange;
                dLimMax = dVal;
            %     set(this.dayAxisWithData, 'Ylim', [dVal (dVal + dRange/2)]);
            end

            if dVal == 0
                dLimMin = dVal ;
                dLimMax = dVal + dRange;
            end
            
            set(this.dayAxisWithData, 'Ylim', [dLimMin dLimMax]);
        end
        
        %Setup patchwork before population of events
        function setUpPatchWork(this)

            timeLabelEv = {'12 am','2 am','4 am','6 am','8 am','10 am','12 pm','2 pm','4 pm','6 pm','8 pm','10 pm','12 am'};
            x = [-.8 .8 .8 -.8];
            
            for tempNum = 0:1:12
                
                pTop = this.maxPatchPos - (this.stepSize*tempNum);
                pBot = pTop - this.thick;
                
                if tempNum == 12
                    
                    textPosY = pTop;
                else
                    pTopNext = this.maxPatchPos - (this.stepSize*(tempNum+1));
                    nextHourLocTop = (pTop + pTopNext)/2;
                    nextHourLocBot = nextHourLocTop - this.thick;
                    yNext = [nextHourLocTop nextHourLocTop nextHourLocBot nextHourLocBot];
                    
                    for tempInt = -.7:.1:.7
                        xNext = [tempInt (tempInt+.05) (tempInt+.5) tempInt];
                        patchLine = patch(xNext,yNext,'red', 'Parent', this.hHggroup, 'EdgeColor', 'none'); 
                    end
                    
                    textPosY = pTop - this.thick/2;
                end
                
                y = [pTop pTop pBot pBot];
                patchLine = patch(x,y,'blue', 'Parent', this.hHggroup, 'EdgeColor', 'none');
                textPosX = -.94;
                text(textPosX, textPosY,timeLabelEv(tempNum+1),'Parent',this.hHggroup);
            end
        end
        
        function specialPatchWorkFull(this, dateID)
            
        % Each second has a used time id. So second number 5 (which is 12:00:05 am and is secondUsageSlot(5) starts off with a value of 0.
        % When the first event occurs during this second, the value of secondUsageSlot(5) changes to 1. IMPORTANT: secondUsageSlot(1)
        % refers to time 0. secondUsageSllot(86400) refers to 86399 or 23:59:59
        
            this.secondUsageSlot =  zeros(1,86400);

            %load data file 
            load('ScheduleDataFile6.mat');

            %find all events recorded for current time range
            eventsOfTheDayStruct = this.specialToolsInstance.filterForSpecificRangeIncRepeats(event6, dateID, '00:00:00', dateID, '23:59:59');

            %Just check if the first entry of field eventID is empty. If so, no events so far that day
            if isempty(eventsOfTheDayStruct) == 1
                disp('no events today')
                return;
            end
            
            %loop through and create individual structures for each camera
            cameraIDlabels = {'Camera1','Camera2','Camera3','Camera4'};
            [~ , camNumberPosibilities] = size(cameraIDlabels);
            for x = 1:1:camNumberPosibilities

                %Individual arrays for each cam created below
                specificCamEvents{x} = this.specialToolsInstance.filterForSpecificCamera(eventsOfTheDayStruct, cameraIDlabels(x));
                %sort for start time
            end

            % Loop through each camera structure 
            for x = 1:1:camNumberPosibilities
                
                %if this specific cam is not scheduled today, nothing needs to happen
                if isempty(specificCamEvents{x}) == 1
                
                %Here we find out where the camera events should print and print them
                else
                    % Loop through events for current cammara structure
                    [~ , totalEventsForCurrentCam] = size(specificCamEvents{x});
                    for xx = 1:1:totalEventsForCurrentCam
                    
                        specificEventStruct = specificCamEvents{x}(xx);
                        this.printSpecificEventPatch(specificEventStruct, dateID);
                    end            
                end    
            end
            this.secondUsageSlot =  zeros(1,86400);
        end
        
        function printSpecificEventPatch(this,specificEventStruct,dateID)
            
            % If start date is not the current date that means for display purposes, the start time will be 0 seconds
            if strcmp(specificEventStruct.dateIDstart, dateID) == 0
                currentStartTime = 0;
                
            % If start date is is the current date, start time will be actual start time
            else
                currentStartTime = this.specialToolsInstance.convertTimeStr2TotalSeconds(specificEventStruct.startTime);
            end

            %If end date is not the current date that means for display purposes, the end time will be 86400 seconds
            if strcmp(specificEventStruct.dateIDend, dateID) == 0
                currentEndTime = 86399;
            % If end date is is the current date, start time will be actual end time
            else
                currentEndTime = this.specialToolsInstance.convertTimeStr2TotalSeconds(specificEventStruct.endTime);
            end

            %If an event is under 30 minutes, it still gets a 30 minute time slot. That means that even if an
            %event lasts 3 hours but ends at 00:15:00.. since its on a new day, the calender will show it until
            %00:30:00;
            if (currentEndTime - currentStartTime <= 1800) && (strcmp(specificEventStruct.dateIDend, dateID) == 1)
                currentEndTime = currentStartTime + 1800; 
            end
            
            %Here we loop through secondUsageSlot to see what the highest value is. if its 0, then 
            %we can print in the first column. If any part has a value, we have to print in the next 
            %column. So we just need to find the largest value.
            maxPossibleSlot = 0;
            for xxx = round((currentStartTime+1):1:(currentEndTime+1))

                if this.secondUsageSlot(1,xxx) > 0
                    if this.secondUsageSlot(1,xxx) > maxPossibleSlot
                        maxPossibleSlot = this.secondUsageSlot(1,xxx);
                    end
                end
            end
            this.secondUsageSlot(round(currentStartTime+1:currentEndTime+1)) = maxPossibleSlot + 1;

            yTop = this.mSlope * currentStartTime + (this.minPatchPos - this.mSlope * this.maxTime);
            yBot = this.mSlope * currentEndTime + (this.minPatchPos - this.mSlope * this.maxTime);
            xPatch = [-.8 -.6 -.6 -.8] + .2*(this.secondUsageSlot(round(currentStartTime+1))-1);
            yPatch = [yTop yTop yBot yBot];

            if strcmp(specificEventStruct.cameraID, 'Camera1') == 1
                colorPatch = 'g';
            elseif strcmp(specificEventStruct.cameraID, 'Camera2') == 1
                colorPatch = 'b';
            elseif strcmp(specificEventStruct.cameraID, 'Camera3') == 1
                colorPatch = 'r';
            elseif strcmp(specificEventStruct.cameraID, 'Camera4') == 1
                colorPatch = 'y';
            end

            this.patchTemp = patch(xPatch,yPatch,colorPatch, 'Parent', this.hHggroup, 'EdgeColor', 'none',...
                        'ButtonDownFcn', {@this.specificEventClicked_cb, specificEventStruct}); 

            text(xPatch(1)+.01,yPatch(1)-.04,specificEventStruct.cameraID,...
                 'UserData', currentEndTime,...
                 'ButtonDownFcn',{@this.specificEventClicked_cb, specificEventStruct});

        end
        
        function specificEventClicked_cb(this,~,~, argument)

            this.camClickedStruct = argument;
            notify(this, 'specificEventClicked');
        end
    end
end
