classdef scheduleMonthClass1 < handle

    properties (SetAccess = public)
        
        schedFig;

        monthBroadPanel;
            sundayLabelMonthBroad;
            mondayLabelMonthBroad;
            tuesdayLabelMonthBroad;
            wednesdayLabelMonthBroad;
            thursdayLabelMonthBroad;
            fridayLabelMonthBroad;
            saturdayLabelMonthBroad;
            
        individualDays;
        
        tempDayNumX;
        tempMonthNumX;
        tempMonthLetX;
        tempYearNumX;
    end
    
    events
        specificDaySelectedFromMonth2;
    end
    
    methods
        function this = scheduleMonthClass1(tempMonthNum, tempMonthLet, tempYearNum) 

            this.tempMonthNumX = tempMonthNum;
            this.tempMonthLetX = tempMonthLet;
            this.tempYearNumX = tempYearNum;
            
            %Month Selector Panel
            this.monthBroadPanel = uipanel('BackgroundColor',[.95 .95 .95], 'BorderType', 'line',...
                       'HighlightColor',[0 0 1], 'BorderWidth', 2,...
                       'Position', [.01 .01 .98 .87]);
                           
                %sundayLabelMonthBroad
                this.sundayLabelMonthBroad = uicontrol('Parent', this.monthBroadPanel, 'Style',...
                               'text', 'String','Sunday', 'FontWeight', 'bold', ...
                               'HorizontalAlignment', 'center', 'FontSize', 14, ...
                               'Position', [20 420 110 30], 'BackgroundColor',[.95 .95 .95]);
                           
                %mondayLabelMonthBroad
                this.mondayLabelMonthBroad = uicontrol('Parent', this.monthBroadPanel, 'Style',...
                               'text', 'String','Monday', 'FontWeight', 'bold', ...
                               'HorizontalAlignment', 'center', 'FontSize', 14, ...
                               'Position', [150 420 110 30], 'BackgroundColor',[.95 .95 .95]);
                           
                %tuesdayLabelMonthBroad
                this.tuesdayLabelMonthBroad = uicontrol('Parent', this.monthBroadPanel, 'Style',...
                               'text', 'String','Tuesday', 'FontWeight', 'bold', ...
                               'HorizontalAlignment', 'center', 'FontSize', 14, ...
                               'Position', [280 420 110 30], 'BackgroundColor',[.95 .95 .95]);
                           
                %wednesdayLabelMonthBroad
                this.wednesdayLabelMonthBroad = uicontrol('Parent', this.monthBroadPanel, 'Style',...
                               'text', 'String','Wednesday', 'FontWeight', 'bold', ...
                               'HorizontalAlignment', 'center', 'FontSize', 14, ...
                               'Position', [410 420 110 30], 'BackgroundColor',[.95 .95 .95]);
                           
                %thursdayLabelMonthBroad
                this.thursdayLabelMonthBroad = uicontrol('Parent', this.monthBroadPanel, 'Style',...
                               'text', 'String','Thursday', 'FontWeight', 'bold', ...
                               'HorizontalAlignment', 'center', 'FontSize', 14, ...
                               'Position', [540 420 110 30], 'BackgroundColor',[.95 .95 .95]);
                           
                %fridayLabelMonthBroad
                this.fridayLabelMonthBroad = uicontrol('Parent', this.monthBroadPanel, 'Style',...
                               'text', 'String','Friday', 'FontWeight', 'bold', ...
                               'HorizontalAlignment', 'center', 'FontSize', 14, ...
                               'Position', [670 420 110 30], 'BackgroundColor',[.95 .95 .95]); 

                %saturdayLabelMonthBroad
                this.saturdayLabelMonthBroad = uicontrol('Parent', this.monthBroadPanel, 'Style',...
                               'text', 'String','Saturday', 'FontWeight', 'bold', ...
                               'HorizontalAlignment', 'center', 'FontSize', 14, ...
                               'Position', [800 420 110 30], 'BackgroundColor',[.95 .95 .95]); 
                           
                           
            %Find out what day the first of the month landed on
            [DayNumber,DayName] = weekday(strcat('01-',this.tempMonthLetX,'-',num2str(this.tempYearNumX)));
            
            %Find out how many days in this month
            totalDaysInMonth = eomday(tempYearNum, tempMonthNum);
            
            currentRowPos = 1;
            currentColPos = DayNumber;
            
            for dayNumm = 1:totalDaysInMonth

                xStart = .015 + (.97/7*currentColPos) - .97/7;
                yStart = .74 - (.85/6*currentRowPos) + .85/6;
                
                dayPanelCoords = [xStart  yStart .98/7 .87/6];
                
                this.tempDayNumX = dayNumm;
                
                this.individualDays{dayNumm} = scheduleDayInMonthClass1(this.monthBroadPanel, dayPanelCoords, this.tempDayNumX, this.tempMonthNumX, this.tempYearNumX);
                addlistener(this.individualDays{dayNumm}, 'specificDaySelectedFromMonth', @this.handleSpecificDaySelected);
                
                currentColPos = currentColPos + 1;
                if currentColPos == 8
                    currentColPos = 1;
                    currentRowPos = currentRowPos + 1;
                end
            end 
        end
        
        function handleSpecificDaySelected(this, src, evt)
            disp('enetered specific day clicked in month class')

            this.tempDayNumX = src.dayNummX;
            this.tempMonthNumX = src.monthNummX;
            this.tempYearNumX = src.yearNummX;
            notify(this, 'specificDaySelectedFromMonth2');
        end
    end
end