        
%%%%%%%%%%%%ORINIAL SETUP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%Checks two events to see if they conflict each other
        function eventsConflictChecker(this, totalEventsStruct, cameraID_PE, startDateID_PE, endDateID_PE, startTime_PE, endTime_PE, repeatIntent_PE, repeatFrequency_PE, repeatOccurences_PE)
            
            %Instance of DateAndTimeTools1
            dateToolsInstance = DateAndTimeTools1;
            
            dateNumForProspectiveEventStartTimeINITIAL = dateToolsInstance.getDateWithTimeNumber(startTime_PE, startDateID_PE);
            dateNumForProspectiveEventEndTimeINITIAL = dateToolsInstance.getDateWithTimeNumber(endTime_PE, endDateID_PE);

            for x = 1:1:totalEventsNumber
                
                dateNumForloopingEventStartTimeINITIAL = dateToolsInstance.getDateWithTimeNumber(totalEventsStruct(x).startTime, totalEventsStruct(x).dateIDstart);
                dateNumForloopingEventEndTimeINITIAL = dateToolsInstance.getDateWithTimeNumber(totalEventsStruct(x).endTime, totalEventsStruct(x).dateIDend);
                
                % If the camera of the current FOR loop event = camera of event attempting creation
                if strcmp(totalEventsStruct(x).cameraID , cameraID_PE) == 1
                    
                    % There are no repeat conditions in prospective event
                    if repeatIntent_PE == 0;
                        
                        % If the date of the current FOR loop event = date of prospective event AND
                        % If the event of the current FOR loop event does not have repeat settings
                        if strcmp(totalEventsStruct(x).dateIDstart , this.dataDateID) == 1 && ...
                           totalEventsStruct(x).repeatFrequency == 0
                       
                            %I took the date = each other out (above) becuase past and future days could never break the
                            % following if statement

                            % Compare events
                            if (dateNumForloopingEventStartTimeINITIAL <= dateNumForProspectiveEventEndTimeINITIAL) && ... 
                                (dateNumForloopingEventEndTimeINITIAL >= dateNumForProspectiveEventStartTimeINITIAL)

                                %FALSE  
                                    
                                %COMPARE TIMING
                                    %getDateNumForProspectiveEventStartTimeINITIAL
                                    %getDateNumForProspectiveEventEndTimeINITIAL
                                        %with
                                    %getDateNumForloopingEventStartTimeINITIAL
                                    %getDateNumForloopingEventEndTimeINITIAL
                                       
                            end
                                

                                
                            
                        % If the date of the current FOR loop event <= date of prospective event AND
                        % If the event of the current FOR loop event DOES have repeat settings    
                        elseif dateNumForloopingEventStartTimeINITIAL <= dateNumForloopingEventStartTimeINITIAL && ...
                               totalEventsStruct(x).repeatFrequency ~= 0
                       
                            for xx = 0:1:totalEventsStruct(x).repeatOccurences
                                
                                %COMPARE TIMING
                                    %1440 mintues in a day. datenum counts by days
                                    %getDateNumForloopingEventStartTimeINITIAL + (event6(x).repeatFrequency/1440) * xx
                                    %getDateNumForloopingEventEndTimeINITIAL + (event6(x).repeatFrequency/1440) * xx
                                        %with
                                    %getDateNumForProspectiveEventStartTimeINITIAL
                                    %getDateNumForProspectiveEventEndTimeINITIAL
                                    
                            end
                        
                        end
                        
                    % YES there are repeat conditions in prospective event    
                    else
                        
                        % The looping event does not have repeat settings AND
                        % The looping event is on the same day or in the future of the prospective event
                        if totalEventsStruct(x).repeatFrequency == 0 && ...
                           dateNumForloopingEventStartTimeINITIAL >= dateNumForloopingEventStartTimeINITIAL
                        
                            for xx = 0:1:repeatOccurences_PE
                       
                                %COMPARE TIMING
                                    %1440 mintues in a day. datenum counts by days
                                    %getDateNumForloopingEventStartTimeINITIAL
                                    %getDateNumForloopingEventEndTimeINITIAL
                                        %with
                                    %getDateNumForProspectiveEventStartTimeINITIAL + (repeatFrequency_PE/1440) * xx
                                    %getDateNumForProspectiveEventEndTimeINITIAL + (repeatFrequency_PE/1440) * xx
                                
                            end
                            
                        % The looping event DOES have repeat settings AND
                        % There is no date restrictions
                        elseif totalEventsStruct(x).repeatFrequency ~= 0
                            
                        	for xx = 0:1:totalEventsStruct(x).repeatOccurences
                                    
                                for xxx = 0:1:repeatOccurences_PE
                                    
                                    %COMPARE TIMING
                                        %getDateNumForProspectiveEventStartTimeINITIAL + (repeatFrequency_PE/1440) * xxx
                                        %getDateNumForProspectiveEventEndTimeINITIAL + (repeatFrequency_PE/1440) * xxx
                                            %with
                                        %getDateNumForloopingEventStartTimeINITIAL + (event6(x).repeatFrequency/1440) * xx
                                        %getDateNumForloopingEventEndTimeINITIAL + (event6(x).repeatFrequency/1440) * xx
                            
                                end
                            end
                        end
                        
                    end
                end
            end
        end
        
        
        
        
        
%%%%%%%%%%%%%%%%%%%%%% VERSION  2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        %Checks two events to see if they conflict each other
        function eventsConflictChecker(this, totalEventsStruct, cameraID_PE, startDateID_PE, endDateID_PE, startTime_PE, endTime_PE, repeatIntent_PE, repeatFrequency_PE, repeatOccurences_PE)
            
            %Instance of DateAndTimeTools1
            dateToolsInstance = DateAndTimeTools1;

            dateNumForProspectiveEventStartTimeINITIAL = dateToolsInstance.getDateWithTimeNumber(startTime_PE, startDateID_PE);
            dateNumForProspectiveEventEndTimeINITIAL = dateToolsInstance.getDateWithTimeNumber(endTime_PE, endDateID_PE);

            for x = 1:1:totalEventsNumber
                
                dateNumForloopingEventStartTimeINITIAL = dateToolsInstance.getDateWithTimeNumber(totalEventsStruct(x).startTime, totalEventsStruct(x).dateIDstart);
                dateNumForloopingEventEndTimeINITIAL = dateToolsInstance.getDateWithTimeNumber(totalEventsStruct(x).endTime, totalEventsStruct(x).dateIDend);
                
                loopEventRepeatFrequency = totalEventsStruct(x).repeatFrequency;
                
                % If the camera of the current FOR loop event = camera of event attempting creation
                if strcmp(totalEventsStruct(x).cameraID , cameraID_PE) == 1
                    
                    % There are no repeat conditions in prospective event
                    if repeatIntent_PE == 0;
                        
                        % If the event of the current FOR loop event does not have repeat settings
                        if startDateID_PEtotalEventsStruct(x).repeatFrequency == 0
                       
                            % Compare timing: 
                            if (dateNumForloopingEventStartTimeINITIAL <= dateNumForProspectiveEventEndTimeINITIAL) && ... 
                                (dateNumForloopingEventEndTimeINITIAL >= dateNumForProspectiveEventStartTimeINITIAL)

                                %FALSE  
                                    
                                %COMPARE TIMING
                                    %dateNumForProspectiveEventStartTimeINITIAL
                                    %dateNumForProspectiveEventEndTimeINITIAL
                                        %with
                                    %dateNumForloopingEventStartTimeINITIAL
                                    %dateNumForloopingEventEndTimeINITIAL
                                       
                            end
                                
                        % If the event of the current FOR loop event DOES have repeat settings    
                        elseif totalEventsStruct(x).repeatFrequency ~= 0
                               
                            for xx = 0:1:totalEventsStruct(x).repeatOccurences
                                
                                % Compare timing: 
                                if (dateNumForloopingEventStartTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)) <= dateNumForProspectiveEventEndTimeINITIAL && ... 
                                    (dateNumForloopingEventEndTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)) >= dateNumForProspectiveEventStartTimeINITIAL
                            
                                    %FALSE
                                
                                    %COMPARE TIMING
                                        %1440 mintues in a day. datenum counts by days
                                        %dateNumForloopingEventStartTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)
                                        %dateNumForloopingEventEndTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)
                                            %with
                                        %dateNumForProspectiveEventStartTimeINITIAL
                                        %dateNumForProspectiveEventEndTimeINITIAL
                                end
                                
                            end
                        
                        end
                        
                    % YES there are repeat conditions in prospective event    
                    else
                        
                        % The looping event does not have repeat settings AND
                        % The looping event is on the same day or in the future of the prospective event
                        if totalEventsStruct(x).repeatFrequency == 0 && ...
                           dateNumForloopingEventStartTimeINITIAL >= dateNumForloopingEventStartTimeINITIAL
                        
                            for xx = 0:1:repeatOccurences_PE
                                
                                % Compare timing: 
                                if dateNumForloopingEventStartTimeINITIAL <= (dateNumForProspectiveEventEndTimeINITIAL  + (repeatFrequency_PE/1440*xx)) && ... 
                                    dateNumForloopingEventEndTimeINITIAL >= (dateNumForProspectiveEventStartTimeINITIAL + (repeatFrequency_PE/1440*xx))
                       
                                    %FALSE

                                    %COMPARE TIMING
                                        %1440 mintues in a day. datenum counts by days
                                        %getDateNumForloopingEventStartTimeINITIAL
                                        %getDateNumForloopingEventEndTimeINITIAL
                                            %with
                                        %getDateNumForProspectiveEventStartTimeINITIAL + (repeatFrequency_PE/1440*xx)
                                        %getDateNumForProspectiveEventEndTimeINITIAL + (repeatFrequency_PE/1440*xx)
                                end
                            end
                            
                        % The looping event DOES have repeat settings AND
                        % There is no date restrictions
                        elseif totalEventsStruct(x).repeatFrequency ~= 0
                            
                        	for xx = 0:1:totalEventsStruct(x).repeatOccurences
                                    
                                for xxx = 0:1:repeatOccurences_PE
                                    
                                    % Compare timing: 
                                    if (dateNumForloopingEventStartTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)) <= (dateNumForProspectiveEventEndTimeINITIAL  + (repeatFrequency_PE/1440*xxx)) && ... 
                                        (dateNumForloopingEventEndTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)) >= (dateNumForProspectiveEventStartTimeINITIAL + (repeatFrequency_PE/1440*xxx))
                                    
                                        %FALSE

                                        %COMPARE TIMING
                                            %dateNumForloopingEventStartTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)
                                            %dateNumForloopingEventEndTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)
                                                %with
                                            %dateNumForProspectiveEventStartTimeINITIAL + (repeatFrequency_PE/1440*xxx)
                                            %dateNumForProspectiveEventEndTimeINITIAL + (repeatFrequency_PE/1440*xxx)
                                    end
                                end
                            end
                        end
                        
                    end
                end
            end
        end
        
        
        
        
        
        
        
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%V3%%%%%%%%%%%%%%%%%%%%%
        %Checks two events to see if they conflict each other
        function eventsConflictChecker(this, totalEventsStruct, cameraID_PE, startDateID_PE, endDateID_PE, startTime_PE, endTime_PE, repeatIntent_PE, repeatFrequency_PE, repeatOccurences_PE)
            
            %Instance of DateAndTimeTools1
            dateToolsInstance = DateAndTimeTools1;

            dateNumForProspectiveEventStartTimeINITIAL = dateToolsInstance.getDateWithTimeNumber(startTime_PE, startDateID_PE);
            dateNumForProspectiveEventEndTimeINITIAL = dateToolsInstance.getDateWithTimeNumber(endTime_PE, endDateID_PE);

            for x = 1:1:totalEventsNumber
                
                dateNumForloopingEventStartTimeINITIAL = dateToolsInstance.getDateWithTimeNumber(totalEventsStruct(x).startTime, totalEventsStruct(x).dateIDstart);
                dateNumForloopingEventEndTimeINITIAL = dateToolsInstance.getDateWithTimeNumber(totalEventsStruct(x).endTime, totalEventsStruct(x).dateIDend);
                
                loopEventRepeatFrequency = totalEventsStruct(x).repeatFrequency;
                
                % If the camera of the current FOR loop event = camera of event attempting creation
                if strcmp(totalEventsStruct(x).cameraID , cameraID_PE) == 1
                    
                    % There are no repeat conditions in prospective event
                    if repeatIntent_PE == 0;
                         
                        for xx = 0:1:totalEventsStruct(x).repeatOccurences

                            % Compare timing: 
                            if (dateNumForloopingEventStartTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)) <= dateNumForProspectiveEventEndTimeINITIAL && ... 
                                (dateNumForloopingEventEndTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)) >= dateNumForProspectiveEventStartTimeINITIAL

                                %FALSE

                            end

                        end
                        
                    % YES there are repeat conditions in prospective event    
                    else
                            
                        	for xx = 0:1:totalEventsStruct(x).repeatOccurences
                                    
                                for xxx = 0:1:repeatOccurences_PE
                                    
                                    % Compare timing: 
                                    if (dateNumForloopingEventStartTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)) <= (dateNumForProspectiveEventEndTimeINITIAL  + (repeatFrequency_PE/1440*xxx)) && ... 
                                        (dateNumForloopingEventEndTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)) >= (dateNumForProspectiveEventStartTimeINITIAL + (repeatFrequency_PE/1440*xxx))
                                    
                                        %FALSE

                                    end
                                end
                            end

                        
                    end
                end
            end
        end
        