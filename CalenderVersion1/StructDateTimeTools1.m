classdef  StructDateTimeTools1 < handle

    properties (SetAccess = public)
    end
    
    methods
        function this = StructDateTimeTools1()

        end

        function newDataStruct = filterForSpecificCamera(this, structureNeedingFilter, cameraID)

        % This creates a new structure that contains all events that exist for a specific camera

            Afields = fieldnames(structureNeedingFilter);
            eventCellArray = struct2cell(structureNeedingFilter);
            szAllData = size(eventCellArray);

            % Matrix Convert
            eventMatrix = reshape(eventCellArray, szAllData(1), []); % Px(MxN), Convert to a matrix
            eventMatrix = eventMatrix'; % (MxN)xP, Make each field a column

            %Finds the total number of events in the calender 
            [~, totalEventsNumber] = size(structureNeedingFilter);

            %Finds the total number of filed catagories 
            [totalFields, ~] = size(Afields);

            eventsInCurrentDayIndex = 0;

            %Find all events with secific camera
            for x = 1:1:totalEventsNumber
                if strcmp(structureNeedingFilter(x).cameraID , cameraID) == 1
                        eventsInCurrentDayIndex = eventsInCurrentDayIndex + 1;
                        eventsInCurrentDayArray(eventsInCurrentDayIndex,:) = eventMatrix(x,:);
                end
            end

            if eventsInCurrentDayIndex == 0
                newDataStruct = {};   
  
            else
                szCurrentDay = [totalFields,1,eventsInCurrentDayIndex];
                CameraSortMatrix = sortrows(eventsInCurrentDayArray, [6,1]); % Sort by 6th field "camera" for entire file
                CameraSortArray = reshape(CameraSortMatrix', szCurrentDay); % Put back into original cell array format
                newDataStruct = cell2struct(CameraSortArray, Afields, 1); % Convert to Struct
            end
        end

        function desiredIndex = findDesiredIndex(this, structureNeedingFilter, fieldName, string)
            
        % This finds the index number in the structure where the fieldName has the specific string we are looking for

            %Finds the total number of events in the calender 
            [~, totalEventsNumber] = size(structureNeedingFilter);

            eventsInCurrentDayIndex = 0;

            for x = 1:1:totalEventsNumber
                if strcmp(structureNeedingFilter(x).(fieldName) , string) == 1
                        eventsInCurrentDayIndex = eventsInCurrentDayIndex + 1;
                        indexVector(eventsInCurrentDayIndex) = x;
                end
            end

            desiredIndex = indexVector;
        end

        function newDataStruct = filterForSpecificRangeIncRepeats(this, structureNeedingFilter, startDate, startTime, endDate, endTime)

        % This creates a new structure that contains all events that exist within the time and date range INCLUDING Repeat events. 
        % So repeat events get their own representation in the structure. The events do not have to start AND end within the range.
        % Just part of them can exist in the range. 
            
            %Instance of DateAndTimeTools1
            dateToolsInstance = DateAndTimeTools1;

            %Finds the total number of events in the calender 
            [~, totalEventsNumber] = size(structureNeedingFilter);

            eventsInCurrentDayIndex = 0;

            newDataStructInitialize = {};

            %These are the starting date and times in datenum form for the range we are filtering for     
            dateNumDesiredStartWithSeconds = dateToolsInstance.getDateWithTimeNumber(startTime, startDate);
            dateNumDesiredEndWithSeconds = dateToolsInstance.getDateWithTimeNumber(endTime, endDate);

            %Find all events starting or ending on and in bewteen the start and end dates and times
            for x = 1:1:totalEventsNumber

                %These are the starting date and times in datenum form for events being checked in loop.     
                initDateNumBeingCheckedStartWithSeconds = dateToolsInstance.getDateWithTimeNumber(structureNeedingFilter(x).startTime, structureNeedingFilter(x).dateIDstart);
                initDateNumBeingCheckedEndWithSeconds = dateToolsInstance.getDateWithTimeNumber(structureNeedingFilter(x).endTime, structureNeedingFilter(x).dateIDend);

                %If no repeat occurence then it will just go through this loop 1 time. 
                for xx = 0:1:structureNeedingFilter(x).repeatOccurences

                    % Compare timing: 
                    currentDateNumBeingCheckedStartWithSeconds = (initDateNumBeingCheckedStartWithSeconds + (structureNeedingFilter(x).repeatFrequency/1440 * xx));
                    currentDateNumBeingCheckedEndWithSeconds = (initDateNumBeingCheckedEndWithSeconds + (structureNeedingFilter(x).repeatFrequency/1440 * xx));
                    if (currentDateNumBeingCheckedStartWithSeconds) <= (dateNumDesiredEndWithSeconds) && ... 
                        (currentDateNumBeingCheckedEndWithSeconds) >= (dateNumDesiredStartWithSeconds)

                         %%HAVE TO CALC DATES AND TIMES FOR REPEATS
                         dataDateIDstart = datestr(currentDateNumBeingCheckedStartWithSeconds, 'YYYYmmDD');
                         dataDateIDend = datestr(currentDateNumBeingCheckedEndWithSeconds, 'YYYYmmDD');
                         startTime = datestr(currentDateNumBeingCheckedStartWithSeconds, 'HH:MM:SS');
                         endTime = datestr(currentDateNumBeingCheckedEndWithSeconds, 'HH:MM:SS');
                         
                         eventsInCurrentDayIndex = eventsInCurrentDayIndex + 1;

                         newDataStructInitialize(eventsInCurrentDayIndex).eventID = structureNeedingFilter(x).eventID;
                         newDataStructInitialize(eventsInCurrentDayIndex).dateIDstart = dataDateIDstart;
                         newDataStructInitialize(eventsInCurrentDayIndex).startTime = startTime;
                         newDataStructInitialize(eventsInCurrentDayIndex).dateIDend = dataDateIDend;
                         newDataStructInitialize(eventsInCurrentDayIndex).endTime = endTime;
                         newDataStructInitialize(eventsInCurrentDayIndex).cameraID = structureNeedingFilter(x).cameraID;
                         newDataStructInitialize(eventsInCurrentDayIndex).action = structureNeedingFilter(x).action;
                         newDataStructInitialize(eventsInCurrentDayIndex).repeatFrequency = structureNeedingFilter(x).repeatFrequency;
                         newDataStructInitialize(eventsInCurrentDayIndex).repeatOccurences = structureNeedingFilter(x).repeatOccurences;
                    end
                end
            end

            newDataStruct = newDataStructInitialize;
        end

        function timeInSeconds = convertTimeStr2TotalSeconds(this,timeString)
            
        % The times passed in this function are in string format 'HH:MM:SS'. I need the time in a variable for many reasons.
        % For example to see if times overlap, for odering, etc. This converts the string to a number  that is the total
        % seconds that have passed since the start of that day '00:00:00'

            numSecondsPerDay = 86400.0;
            timeFractional = datenum(timeString); % convert times to fractional days using datenum
            timeFraction = mod(timeFractional,1); % leave only the part with the most recent day fraction
            timeInSeconds = timeFraction * numSecondsPerDay; % multiply by number of seconds in a day
        end

        function eventID = getEventID(this, cameraID, startDate, startTime, repeatFrequency, repeatOccurences)
            
        % for example 'Camera1_20100101_000000_RF_2_RO_10'

           strRF = num2str(repeatFrequency);
           strRO = num2str(repeatOccurences);

           startTimeFin = regexprep(startTime,'[:]','');
           eventID = strcat(cameraID, '_', startDate, '_', startTimeFin, '_', 'RF', strRF, 'RO',strRO);
        end
        
        function dateWithTimeNumber = geDateNumberFromEventID(this, eventID)
        
        % This gets the date number from eventID ('Camera1_20150101_013010_RF_2_RO_10'). This might need to get streemlined later on.
         
            str = eventID;
            expressionMatchDate = '\d{8,8}'; % 8 number is a row (20150101)
            expressionMatchTime = '\d{6,6}'; % 6 number is a row (013010)
            regMatchDate = regexp(str,expressionMatchDate,'match');
            regMatchTime = regexp(str,expressionMatchTime,'match');
            
            timeString = strcat(regMatchTime{2}(1:2),':',regMatchTime{2}(3:4),':',regMatchTime{2}(5:6));
            
            dateWithTimeNumber = this.getDateWithTimeNumber(timeString, regMatchDate{1});
        end
        
        function yearPopUpString = getYearPopUpString(this, dateNumber)
            
        % ('yyyy|yyyy|yyyy|yyyy|yyyy') for example ('2013|2014|2015|2016|2017'). Getting years before and after current year for scroll options
            
            currentYearNum = str2num(datestr(dateNumber, 'YYYY'));
            currentYearStr = num2str(currentYearNum);
            yearBeforeStr = num2str(currentYearNum - 1);
            twoYearsBeforeStr = num2str(currentYearNum - 2);
            yearAfterStr = num2str(currentYearNum + 1);
            twoYearsAfterStr = num2str(currentYearNum + 2);
            yearPopUpString = strcat(twoYearsBeforeStr,'|',yearBeforeStr,'|',currentYearStr,'|',yearAfterStr,'|',twoYearsAfterStr);

        end
        
        function dayPopUpString = getDayPopUpString(this, dateNumber)
            
        %('dd|dd|dd|dd|...') for example ('1|2|3|...'). Getting years before and after current year for scroll options
            
            currentMonthNum = str2num(datestr(dateNumber, 'mm'));
            currentYearNum = str2num(datestr(dateNumber, 'yyyy'));
            
            %Find out how many days in this month
            totalDaysInMonth = eomday(currentYearNum, currentMonthNum);
            
            dayPopUpStringTemp = '1';
            for dayNumm = 2:totalDaysInMonth
                
                dayPopUpStringTemp = strcat(dayPopUpStringTemp,'|',num2str(dayNumm));
            end
            
            dayPopUpStringTemp = strcat(dayPopUpStringTemp,'|','None');
            dayPopUpString = dayPopUpStringTemp;
        end

        function [hour24var, hour24String] = TwelveHourFormatTo24HourFormatHOUR(this, hourString, amPMstring)
            
        % converts 12 hour format for hours to 24 hour format in var and string.
        % for ex/ '6' and 'am' would be '06' and 6
        % for ex/ '6' and 'pm' would be '18' and 18
            
            % 1pm to 12am turns to 13 to 24
            if strcmp(amPMstring, 'pm') == 1 && ...
               str2num(hourString) < 12

                    hour24var = str2num(hourString) + 12;
                    hour24String = num2str(hour24var);
            
            % 12am turns to 00
            elseif strcmp(amPMstring, 'am') == 1 && ...
               str2num(hourString) == 12

                    hour24var = 0;
                    hour24String = strcat('0',num2str(hour24var));

            % 1 am to 9 am turns to 01 to 09
            elseif strcmp(amPMstring, 'am') == 1 && ...
               str2num(hourString) < 10

                    hour24String = strcat('0',hourString);
                    hour24var = str2num(hour24String);

            % 10 am to 12 pm turns to 10 to 12
            else
                    hour24string = hourString;
                    hour24var = str2num(hour24string);
            end

        end
        
        function dateWithTimeNumber = getDateWithTimeNumber(this, timeString, dateString)
            
        % Input are strings: timeString 'hh:mm:ss' and dateString 'yyyymmdd'
        % Output should be a full date number down to the second. 
        % DateNumber = datenum(Y,M,D,H,MN,S) 
            
            hourString = timeString(1:2);
            minuteString = timeString(4:5);
            secondString = timeString(7:8);
            
            hourNum = str2num(hourString);
            minuteNum = str2num(minuteString);
            secondNum = str2num(secondString);
            
            yearString = dateString(1:4);
            monthString = dateString(5:6);
            dayString = dateString(7:8);
            
            yearNum = str2num(yearString);
            monthNum = str2num(monthString);
            dayNum = str2num(dayString);
            
            dateWithTimeNumber = datenum(yearNum,monthNum,dayNum,hourNum,minuteNum,secondNum);
        end
    end
end












