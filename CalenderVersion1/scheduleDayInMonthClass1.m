classdef scheduleDayInMonthClass1 < handle

    
    properties (SetAccess = public)
        
        monthBroadPanel;
        

        dayNummX;
        monthNummX;
        yearNummX;
        
        colorScheme;
        eventColorScheme;
        cameraColorScheme;
        
        eventStringSched;
        cameraStringSched;
        
        dayPanelCoordsX;
        
        dayInMonthPanel;
        
        dayNumberLabel;
        schedSummaryCamerasLabel;
        schedSummaryEventsLabel;
        
        expandDayRadioButton;
        
    end
    
    events
        specificDaySelectedFromMonth;
    end
    
    methods
        function this = scheduleDayInMonthClass1(monthBroadPanel, dayPanelCoords, dayNumm, monthNumm, yearNumm)  
            
            this.dayNummX = dayNumm;
            this.monthNummX = monthNumm;
            this.yearNummX = yearNumm;
            
            this.dayPanelCoordsX = dayPanelCoords;
            
            %this just changes the colorof the day in month panel if it is
            %on the current day
            if str2num(datestr(clock,'mm')) == this.monthNummX && ...
               str2num(datestr(clock,'dd')) == this.dayNummX && ...
               str2num(datestr(clock,'yyyy')) == this.yearNummX
                
                    this.colorScheme = [.85 1 1];
            else
                    this.colorScheme = [1 1 1];
            end
            
            
            this.scheduleSummary
            
            %Month Selector Panel
            this.dayInMonthPanel = uipanel('Parent', monthBroadPanel, 'BackgroundColor',this.colorScheme,...
                       'BorderType', 'line', 'HighlightColor',[0 0 0], 'BorderWidth', 1,...
                       'Position', this.dayPanelCoordsX);
                   
                %String for day number
                this.dayNumberLabel = uicontrol('Parent', this.dayInMonthPanel, 'Style',...
                               'text', 'String',this.dayNummX, ...
                               'HorizontalAlignment', 'center', 'FontSize', 10, ...
                               'Position', [5 45 20 20], 'BackgroundColor',this.colorScheme); 
                           
                %String for sched summary for cameras
                this.schedSummaryCamerasLabel = uicontrol('Parent', this.dayInMonthPanel, 'Style',...
                               'text', 'String', this.cameraStringSched, ...
                               'HorizontalAlignment', 'center', 'FontSize', 10, ...
                               'Position', [10 27 100 20], 'BackgroundColor', this.cameraColorScheme,...
                               'ForegroundColor', [0 0 .9]); 
                           
                %String for sched summary for events
                this.schedSummaryEventsLabel = uicontrol('Parent', this.dayInMonthPanel, 'Style',...
                               'text', 'String', this.eventStringSched, ...
                               'HorizontalAlignment', 'center', 'FontSize', 10, ...
                               'Position', [10 7 100 20], 'BackgroundColor', this.eventColorScheme,...
                               'ForegroundColor', 'red');
                           
                % The open day radio button                                 
                this.expandDayRadioButton = uicontrol('Parent', this.dayInMonthPanel, 'Style', 'radiobutton',...
                           'Value', 0 , 'Position', [105 50 15 15],...
                           'Callback', @this.expandDay_cb, 'BackgroundColor',this.colorScheme);
                       
                       
        end
        
        function scheduleSummary(this)
            
            %This should probably be set unviversally somewhere else
            totalCamerasNum = 4;
            
            %load data file 
            load('ScheduleDataFile6.mat');
            
            %Instance of StructureOrdering2
            structureOrdInstance = StructureOrdering2;
            
            dateVector = [this.yearNummX, this.monthNummX, this.dayNummX, 0, 0, 0];
            dateID = datestr(dateVector,'YYYYmmDD');

            %find all events recorded for current time range
            eventsOfTheDayStruct = structureOrdInstance.filterForSpecificRangeIncRepeats(event6, dateID, '00:00:00', dateID, '23:59:59');
            
            [~,numberOfEventsNum] = size(eventsOfTheDayStruct);
            numberOfEventsStr = num2str(numberOfEventsNum);
            
            if numberOfEventsNum == 0
                
                this.eventStringSched = ' ';
                this.eventColorScheme = this.colorScheme; 
                this.cameraColorScheme = this.colorScheme;

                this.cameraStringSched = ' ';
            else
                
                %We could change this for aesthetics later
                this.eventColorScheme = this.colorScheme; 
                this.cameraColorScheme = this.colorScheme;
                
                cameraEventLog = [];
                for x = 1:1:totalCamerasNum
                    
                    if x == 1
                        cameraID = 'Camera1';
                    elseif x == 2
                        cameraID = 'Camera2';
                    elseif x == 3
                        cameraID = 'Camera3';
                    elseif x == 4
                        cameraID = 'Camera4';
                    end
                    
                    newDataStruct = structureOrdInstance.filterForSpecificCamera(eventsOfTheDayStruct, cameraID);
                    [~,numberOfEventsNumForCam] = size(newDataStruct);
                    cameraEventLog(x) = numberOfEventsNumForCam;

                end
                
                %These two if else statements are just for grammer. 1 event versus 2 eventS
                if numberOfEventsNum == 1
                    this.eventStringSched = strcat(numberOfEventsStr, ' event');
                else
                    this.eventStringSched = strcat(numberOfEventsStr, ' events');
                end
                numberOfCamerasNum = length(find(cameraEventLog ~= 0));
                numberOfCamerasStr = num2str(numberOfCamerasNum);
                if numberOfCamerasNum == 1
                    this.cameraStringSched = strcat(numberOfCamerasStr, ' camera');
                else
                    this.cameraStringSched = strcat(numberOfCamerasStr, ' cameras');
                end

            end
            
            
        end
        
        function expandDay_cb(this,~,~)
            
            notify(this, 'specificDaySelectedFromMonth');

        end

    end
    
end