classdef ScheduleClass2 < handle
    
    properties (SetAccess = private)
        
    schedFig;

    timeScaleView;
       
    dayTimeFrameViewMP;
    monthTimeFrameViewMP;
    yearTimeFrameViewMP;

    monthView; %scheduleMonthClass1 instance
    dayView; %scheduleDayClass7 instance
            
    dayClassExists;
    monthClassExists;
    
    specialToolsInstance;
        
    end

    methods
        function this = ScheduleClass2()  

            currentDate = clock;
            currentDateNumber = datenum(currentDate);
            
            % Instance of StructDateTimeTools1
            this.specialToolsInstance = StructDateTimeTools1;
            
            %Year pop up string
            yearPopUpString = this.specialToolsInstance.getYearPopUpString(currentDateNumber);
            
            %Day pop up string
            dayPopUpString = this.specialToolsInstance.getDayPopUpString(currentDateNumber);

            %Current month Number
            currentMonthNum = str2num(datestr(currentDate, 'mm'));

            %Current day Number
            currentDayNum = str2num(datestr(currentDate, 'dd'));
            
            this.schedFig = figure('Position',[100,50,960,540],...
            'Resize','off','Color',[0.78,0.86,1.0]);
        
            %Panel for selecting month year day popup
            timeScaleViewPanel = uipanel('BackgroundColor',[.65 .95 .95], 'BorderType', 'line',...
                       'HighlightColor',[1 0 0], 'BorderWidth', 2, 'Units', 'pixels',...
                       'Position', [10 480 192 54]);
        
                    %Title text of drop down view menu
                    uicontrol('Parent', timeScaleViewPanel, 'Style',...
                               'text', 'String','Scale:', 'FontWeight', 'bold', ...
                               'HorizontalAlignment', 'left', 'FontSize', 10, ...
                               'Position', [10 10 45 25], 'BackgroundColor',[.65 .95 .95]);

                    % The drop down view menu to selected month, day, or year view                               
                    this.timeScaleView = uicontrol('Parent', timeScaleViewPanel, 'Style', 'popup',...
                               'FontSize', 10, 'String', 'Day|Month','Value', 1,...
                               'Position', [65 10 100 30], 'Callback', @this.scaleView_cb);
   
            %Panel that has day month and year specific options (monthSelectorPanel) should change name
            monthSelectorPanel = uipanel('BackgroundColor',[.95 .95 .95], 'BorderType', 'line',...
                       'HighlightColor',[1 0 0], 'BorderWidth', 2,'Units', 'pixels',...
                       'Position', [201 480 432 54]);
                   
                    %Title text of Day drop down view menu in month Paenl (MP)
                    uicontrol('Parent', monthSelectorPanel, 'Style',...
                               'text', 'String','Day:', 'FontWeight', 'bold', ...
                               'HorizontalAlignment', 'left', 'FontSize', 10, ...
                               'Position', [10 10 45 25], 'BackgroundColor',[.95 .95 .95]);

                    % The drop down view menu to select Day in month panel (MP)                             
                    this.dayTimeFrameViewMP = uicontrol('Parent', monthSelectorPanel, 'Style', 'popup',...
                               'String', dayPopUpString,...
                               'Value', currentDayNum, 'FontSize', 10, 'Position', [50 10 70 30],...
                               'Callback', @this.dayTimeFrameView_cb);
                   
                    uipanel('Parent', monthSelectorPanel,'BackgroundColor',[.95 .95 .95],...
                        'BorderType', 'line', 'HighlightColor',[0 0 0], 'BorderWidth', 2,...
                       'Position', [.31 0 .005 1]);
                   
                    %Title text of MONTH drop down view menu in month Paenl (MP)
                    uicontrol('Parent', monthSelectorPanel, 'Style',...
                               'text', 'String','Month:', 'FontWeight', 'bold', ...
                               'HorizontalAlignment', 'left', 'FontSize', 10, ...
                               'Position', [145 10 45 25], 'BackgroundColor',[.95 .95 .95]);

                    % The drop down view menu to select Month in month panel (MP)                             
                    this.monthTimeFrameViewMP = uicontrol('Parent', monthSelectorPanel, 'Style', 'popup',...
                               'String', 'January|February|March|April|May|June|July|August|September|October|November|December',...
                               'Value', currentMonthNum, 'FontSize', 10, 'Position', [200 10 80 30],...
                               'Callback', @this.monthTimeFrameView_cb);
                               
                    uipanel('Parent', monthSelectorPanel,'BackgroundColor',[.95 .95 .95],...
                        'BorderType', 'line', 'HighlightColor',[0 0 0], 'BorderWidth', 2,...
                       'Position', [.68 0 .005 1]);
                               
                    %Title text of Year drop down view menu in month Paenl (MP)
                    uicontrol('Parent', monthSelectorPanel, 'Style',...
                               'text', 'String','Year:', 'FontWeight', 'bold', ...
                               'HorizontalAlignment', 'left', 'FontSize', 10, ...
                               'Position', [300 10 35 25], 'BackgroundColor',[.95 .95 .95]);

                    % The drop down view menu to select Year in month panel (MP)                             
                    this.yearTimeFrameViewMP = uicontrol('Parent', monthSelectorPanel, 'Style', 'popup',...
                               'String', yearPopUpString,...
                               'Value', 3, 'FontSize', 10, 'Position', [345 10 70 30],...
                               'Callback', @this.yearTimeFrameView_cb);

                 this.dayView = scheduleDayClass7(currentDateNumber);
                 addlistener(this.dayView, 'eventCreated', @this.handleEventCreated);
                 addlistener(this.dayView, 'eventDeleted', @this.handleEventDeleted);
                 addlistener(this.dayView, 'eventAltered', @this.handleEventAltered);
                 
                 this.dayClassExists = 1;
        end
        
        function scaleView_cb(this,~,~)

            %If day scale was selected
            a = get(this.dayTimeFrameViewMP, 'String');
            if get(this.timeScaleView,'Value') == 1 && strcmp(a(end), 'e') == 1

                set(this.timeScaleView, 'Value', 2); %To month 

            %If month scale was selected
            elseif get(this.timeScaleView,'Value') == 2
                
                currentMonthNum = get(this.monthTimeFrameViewMP, 'Value');
                
                currentMonthLetFullList = cellstr(get(this.monthTimeFrameViewMP,'String'));
                currentMonthLetFullName = char(currentMonthLetFullList(currentMonthNum));
                currentMonthLet = currentMonthLetFullName(1:3);

                currentYearPopUpValue = get(this.yearTimeFrameViewMP,'Value');
                currentYearNumFullList = cellstr(get(this.yearTimeFrameViewMP,'String'));
                currentYearNum = str2num(char(currentYearNumFullList(currentYearPopUpValue)));
                
                %We need to reset the total days in this month for the day scroll and set the current day to none
                currentDateNumber = datenum(currentYearNum, currentMonthNum, 1);

                dayPopUpString = this.specialToolsInstance.getDayPopUpString(currentDateNumber);
                set(this.dayTimeFrameViewMP, 'String', dayPopUpString);

                totalDaysInMonth = eomday(currentYearNum, currentMonthNum);
                set(this.dayTimeFrameViewMP, 'Value', totalDaysInMonth + 1);
                
                %Hides then deletes month class and panel if it exists
                if this.monthClassExists == 1
                    this.closeDownMonthClassInstance;
                end

                %Hides then deletes day class and panel if it exists
                if this.dayClassExists == 1
                    this.closeDownDayClassInstance;
                end

                this.monthView = scheduleMonthClass1(currentMonthNum, currentMonthLet, currentYearNum);
                addlistener(this.monthView, 'specificDaySelectedFromMonth2', @this.handleSpecificDaySelected2);
                this.monthClassExists = 1;
            end     
        end
        
        function monthTimeFrameView_cb(this,~,~)
            
            set(this.timeScaleView, 'Value', 2);
            
            currentMonthNum = get(this.monthTimeFrameViewMP,'Value');
            currentYearPopUpValue = get(this.yearTimeFrameViewMP,'Value');
            
            currentMonthLetFullList = cellstr(get(this.monthTimeFrameViewMP,'String'));
            currentMonthLetFullName = char(currentMonthLetFullList(currentMonthNum));
            currentMonthLet = currentMonthLetFullName(1:3);
            
            currentYearNumFullList = cellstr(get(this.yearTimeFrameViewMP,'String'));
            currentYearNum = str2num(char(currentYearNumFullList(currentYearPopUpValue)));

            %We need to reset the total days in this month for the day scroll and set the current day to none
            currentDateNumber = datenum(currentYearNum, currentMonthNum, 1);
            dayPopUpString = this.specialToolsInstance.getDayPopUpString(currentDateNumber);
            set(this.dayTimeFrameViewMP, 'String', dayPopUpString);
            
            totalDaysInMonth = eomday(currentYearNum, currentMonthNum);
            set(this.dayTimeFrameViewMP, 'Value', totalDaysInMonth + 1);
            
            %Hides then deletes month class and panel if it exists
            if this.monthClassExists == 1
                this.closeDownMonthClassInstance;
            end
            
            %Hides then deletes day class and panel if it exists
            if this.dayClassExists == 1
                this.closeDownDayClassInstance;
            end

            this.monthView = scheduleMonthClass1(currentMonthNum, currentMonthLet, currentYearNum);
            addlistener(this.monthView, 'specificDaySelectedFromMonth2', @this.handleSpecificDaySelected2);
            this.monthClassExists = 1;
        end
        
        function yearTimeFrameView_cb(this,~,~)
            
            set(this.timeScaleView, 'Value', 2);
            
            %Hides then deletes month class and panel if it exists
            if this.monthClassExists == 1
                this.closeDownMonthClassInstance;
            end
            
            %Hides then deletes day class and panel if it exists
            if this.dayClassExists == 1
                this.closeDownDayClassInstance;
            end
            
            currentMonthNum = get(this.monthTimeFrameViewMP,'Value');
            currentYearPopUpValue = get(this.yearTimeFrameViewMP,'Value');
            
            currentMonthLetFullList = cellstr(get(this.monthTimeFrameViewMP,'String'));
            currentMonthLetFullName = char(currentMonthLetFullList(currentMonthNum));
            currentMonthLet = currentMonthLetFullName(1:3);
            
            currentYearNumFullList = cellstr(get(this.yearTimeFrameViewMP,'String'));
            currentYearNum = str2num(char(currentYearNumFullList(currentYearPopUpValue)));
            
            this.monthView = scheduleMonthClass1(currentMonthNum, currentMonthLet, currentYearNum);
            addlistener(this.monthView, 'specificDaySelectedFromMonth2', @this.handleSpecificDaySelected2);
            this.monthClassExists = 1;
        end
        
        function dayTimeFrameView_cb(this,~,~)

            set(this.timeScaleView, 'Value', 1);
            
            currentMonthNum = get(this.monthTimeFrameViewMP,'Value');
            currentYearPopUpValue = get(this.yearTimeFrameViewMP,'Value');
            currentDayNum = get(this.dayTimeFrameViewMP,'Value');
            
            currentMonthLetFullList = cellstr(get(this.monthTimeFrameViewMP,'String'));
            currentMonthLetFullName = char(currentMonthLetFullList(currentMonthNum));
            currentMonthLet = currentMonthLetFullName(1:3);
            
            currentYearNumFullList = cellstr(get(this.yearTimeFrameViewMP,'String'));
            currentYearNum = str2num(char(currentYearNumFullList(currentYearPopUpValue)));
            
%             currentDayNumFullList = cellstr(get(this.dayTimeFrameViewMP,'String'));
%             currentDayNum = str2num(char(currentYearNumFullList(currentYearPopUpValue)));  

            %Hides then deletes month class and panel if it exists
            if this.monthClassExists == 1
                this.closeDownMonthClassInstance;
            end
            
            %Hides then deletes day class and panel if it exists
            if this.dayClassExists == 1
                this.closeDownDayClassInstance;
            end

            %If none was selected
            totalDaysInMonth = eomday(currentYearNum, currentMonthNum);
            if totalDaysInMonth < currentDayNum
                set(this.timeScaleView, 'Value', 2);
                this.monthView = scheduleMonthClass1(currentMonthNum, currentMonthLet, currentYearNum);
                addlistener(this.monthView, 'specificDaySelectedFromMonth2', @this.handleSpecificDaySelected2);
                this.monthClassExists = 1;
                
            else
                currentDateNumber = datenum(currentYearNum, currentMonthNum, currentDayNum);
                this.dayView = scheduleDayClass7(currentDateNumber);
                addlistener(this.dayView, 'eventCreated', @this.handleEventCreated);
                addlistener(this.dayView, 'eventDeleted', @this.handleEventDeleted);
                addlistener(this.dayView, 'eventAltered', @this.handleEventAltered);
                this.dayClassExists = 1;
            end  
        end 
        
        function handleSpecificDaySelected2(this, src, evt)

            set(this.timeScaleView, 'Value', 1);
            set(this.dayTimeFrameViewMP, 'Value', src.tempDayNumX);

            %Hides then deletes month class and panel if it exists
            if this.monthClassExists == 1
                this.closeDownMonthClassInstance;
            end
            
            %Hides then deletes day class and panel if it exists
            if this.dayClassExists == 1
                this.closeDownDayClassInstance;
            end
            
            selectedDateNum = datenum(src.tempYearNumX, src.tempMonthNumX, src.tempDayNumX);
            this.dayView = scheduleDayClass7(selectedDateNum);
            addlistener(this.dayView, 'eventCreated', @this.handleEventCreated);
            addlistener(this.dayView, 'eventDeleted', @this.handleEventDeleted);
            addlistener(this.dayView, 'eventAltered', @this.handleEventAltered);
            this.dayClassExists = 1;
            
        end
        
        function handleEventCreated(this, src, evt)

            load('ScheduleDataFile6.mat')

            event6(end + 1).eventID = src.eventID2bC;
            event6(end).dateIDstart = src.startDateID2bC;
            event6(end).startTime = src.startTime2bC;
            event6(end).dateIDend = src.endDateID2bC;
            event6(end).endTime = src.endTime2bC;
            event6(end).cameraID = src.cameraID2bC;
            event6(end).action = src.action2bC;
            event6(end).repeatFrequency = src.repeatFrequencyNumber2bC;
            event6(end).repeatOccurences = src.repeatTotalOccurenceNumber2bC;

            save('ScheduleDataFile6.mat', 'event6');
            
            set(src.messageBoardText, 'ForegroundColor', [0 .6 0]);
            set(src.messageBoardText, 'String', 'Event successfully created');
        end
   
        function handleEventDeleted(this, src, evt)

            load('ScheduleDataFile6.mat');
            event6(src.indexNumsOfEventToBeAltered) = [];
            save('ScheduleDataFile6.mat','event6');
        end
        
        function handleEventAltered(this, src, evt)

            load('ScheduleDataFile6.mat');
            
            event6(src.indexNumsOfEventToBeAltered).eventID = src.eventID2bA;
            event6(src.indexNumsOfEventToBeAltered).dateIDstart = src.startDateID2bA;
            event6(src.indexNumsOfEventToBeAltered).startTime = src.startTime2bA;
            event6(src.indexNumsOfEventToBeAltered).dateIDend = src.endDateID2bA;
            event6(src.indexNumsOfEventToBeAltered).endTime = src.endTime2bA;
            event6(src.indexNumsOfEventToBeAltered).cameraID = src.cameraID2bA;
            event6(src.indexNumsOfEventToBeAltered).action = src.action2bA;
            event6(src.indexNumsOfEventToBeAltered).repeatFrequency = src.repeatFrequencyNumber2bA;
            event6(src.indexNumsOfEventToBeAltered).repeatOccurences = src.repeatTotalOccurenceNumber2bA;
            
            save('ScheduleDataFile6.mat','event6');
        end
        
        function closeDownDayClassInstance(this)
             set(this.dayView.repeatOptionsPanel, 'Visible', 'off');
             set(this.dayView.specificEventInfoPanel, 'Visible', 'off');
             set(this.dayView.dayNarrowPanel, 'Visible', 'off');
             set(this.dayView.dayTakeActionPanel, 'Visible', 'off');
             cla(this.dayView.patchWorkView.dayAxisWithData);
             clear this.dayView;
             this.dayClassExists = 0;
        end
        
        function closeDownMonthClassInstance(this)
             set(this.monthView.monthBroadPanel, 'Visible', 'off');
             clear this.monthView;
             this.monthClassExists = 0;
        end
        
        function delete(this)

         end
    end
end

