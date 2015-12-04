classdef scheduleDayClass7 < handle

    
    properties (SetAccess = public)
        
    specialToolsInstance;

    %scheduleDayClass6 ui properties
    dayNarrowPanel;

    %takeActionPanelBuild ui properties           
    dayTakeActionPanel;

    eventCameraSelectionPopUpBox;
    
    snapshotBorder;
    burstBorder;
    videoBorder;
    
    viewSnapshot;
    viewBurst;
    viewVideo;
    
    snapshotPanel;
    specificSaveCheckBoxSnapshot;
    specificSaveEditBoxSnapshot;
    
    burstPanel;
    captureSeriesFrameNumberEditBurst;
    captureSeriesTimeNumberEditBurst;
    specificSaveCheckBoxBurst;
    specificSaveEditBoxBurst;
    
    videoPanel;
    
    messageBoardPanel;
    messageBoardText;
    overwriteButton;
    cancelButton;

    startTimeHourPopUp;
    startTimeMinutePopUp;
    startTimeAmPmPopUp;
    
    repeatActionSelectionText;
    
    %specificEventInfoPanelBuild ui properties            
    specificEventInfoPanel;
    
    messageBoardSpecificEventPanel;
    messageBoardSpecificText;
    
    %repeatOptionsPanelBuild ui properties
    repeatOptionsPanel;
    numberRepeatFrequencyRoP;
    stringRepeatFrequencyPopUpBoxRoP;
    numberRepeatTotalOccurencesRoP;
    messageBoardRepeatOptionsPanel;
    messageBoardRepeatOptionsText; 

    %other properties
    dataDateID;
    dateNumber;
    patchWorkView;

    repeatFrequencyNumber = 0; %Repeats once every X minutes
    repeatTotalOccurenceNumber = 0; %Total repeat occurences
    
    %These elements are sent to notify eventCreated 2bC (to be Created)
    eventID2bC;
    startDateID2bC;
    startTime2bC;
    endDateID2bC;
    endTime2bC;
    cameraID2bC;
    action2bC;
    repeatFrequencyNumber2bC;
    repeatTotalOccurenceNumber2bC;
    
    %These elements are sent to notify eventAltered 2bA (to be Altered)
    eventID2bA;
    startDateID2bA;
    startTime2bA;
    endDateID2bA;
    endTime2bA;
    cameraID2bA;
    action2bA;
    repeatFrequencyNumber2bA;
    repeatTotalOccurenceNumber2bA;
 
    specificEventStructToBeAltered;
    indexNumsOfEventToBeAltered;
    eventIDsOfConflictingEvents;

    end
    
	events
        eventCreated;
        eventAltered;
        eventDeleted;
    end
    
    methods
        function this = scheduleDayClass7(dateNumber)
            
            % Instance of StructDateTimeTools1
            this.specialToolsInstance = StructDateTimeTools1;
            
            this.dateNumber = dateNumber;
            
            %Day Panel label
            dayPanelLabel = datestr(this.dateNumber,'ddd mmm dd, yyyy');
            
            %dataDateID ('yyyymmdd')
            this.dataDateID = datestr(this.dateNumber, 'YYYYmmDD');

            %Day Selector Panel
            this.dayNarrowPanel = uipanel('BackgroundColor',[.95 .95 .95], 'BorderType', 'line',...
                       'HighlightColor',[0 0 1], 'BorderWidth', 2, 'Units', 'pixels',...
                       'Position', [10 5 672 470]);
                           
                %Current Day label 
                uicontrol('Parent', this.dayNarrowPanel, 'Style',...
                               'text', 'String',dayPanelLabel, 'FontWeight', 'bold', ...
                               'HorizontalAlignment', 'center', 'FontSize', 14, ...
                               'Position', [10 442 190 20], 'BackgroundColor',[.95 .95 .95]);
              
             this.patchWorkView = patchBuilderDaySchedule3(this.dayNarrowPanel,this.dataDateID);
             addlistener(this.patchWorkView, 'specificEventClicked', @this.handleSpecificEventClicked);

             this.takeActionPanelBuild;
             this.repeatOptionsPanelBuild;

        end
        
        %Builds the panel where we can schedule events
        function takeActionPanelBuild(this)
            
            %Day Take action Panel
            this.dayTakeActionPanel = uipanel('BackgroundColor',[.95 .95 .95], 'BorderType', 'line',...
                       'HighlightColor',[0 0 1], 'BorderWidth', 2, 'Position', [.72 .01 .27 .87],...
                       'Visible', 'on');
                   
                    %Create or edit event title
                    uicontrol('Parent', this.dayTakeActionPanel, 'Style',...
                                   'text', 'String','Create Event', 'FontWeight', 'bold', ...
                                   'HorizontalAlignment', 'center', 'FontSize', 14, ...
                                   'Position', [38 435 190 25], 'BackgroundColor',[.95 .95 .95]);
                    
                               
                    %Event DateID text label
                    uicontrol('Parent', this.dayTakeActionPanel, 'Style',...
                                   'text', 'String','Date ID:', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 10, ...
                                   'Position', [14 410 55 18], 'BackgroundColor',[.95 .95 .95]);
                               
                               
                    %Event dateID panel (for aesthetics)      
                    eventDateIDpanel = uipanel('Parent',this.dayTakeActionPanel, ...
                                           'BackgroundColor',[1 1 1],...
                                           'BorderType', 'line',...
                                           'HighlightColor', [1 0 0],...
                                           'Position', [.27 .88 .32 .037]);
                                       
                             %event date text box  (dataDateID)                              
                             uicontrol('Parent', eventDateIDpanel, 'Style',...
                                       'text', 'String', this.dataDateID, 'FontSize', 10, ...
                                       'Position', [10 1 65 14], 'BackgroundColor',[1 1 1]);        
                               
                               
                    %Event Camera selection text label
                    uicontrol('Parent', this.dayTakeActionPanel, 'Style',...
                                   'text', 'String','Camera:', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 10, ...
                                   'Position', [14 381 55 18], 'BackgroundColor',[.95 .95 .95]);
                               
                               
                    %Event cam selection panel (for aesthetics)      
                    eventCameraSelectionPanel = uipanel('Parent',this.dayTakeActionPanel, ...
                                           'BackgroundColor',[.9 .9 .9],...
                                           'BorderType', 'line',...
                                           'HighlightColor', [1 0 0],...
                                           'Position', [.27 .81 .40 .051]);
                                       
                             %event cam selection list box                                 
                             this.eventCameraSelectionPopUpBox = uicontrol('Parent', eventCameraSelectionPanel, ...
                                    'Style', 'popup', 'String', 'Please Select|Camera1|Camera2|Camera3|Camera4','Value',1,...
                                    'Position', [1 9 100 14],'BackgroundColor',[1 1 1]);
                                
  
                %THE NEXT THREE ARE FOR AESTHETICS ONLY. to give the panel a more tab-like feel       
                       
                this.snapshotBorder = uicontrol('Parent',this.dayTakeActionPanel, ...
                           'Style', 'text', 'String', ...
                           ' ', 'Visible', 'on',...
                           'HorizontalAlignment', 'left', 'FontSize', 8, ...
                           'Position', [1 343 85 29], 'BackgroundColor',[0 0 0]);
                       
                this.burstBorder = uicontrol('Parent',this.dayTakeActionPanel, ...
                           'Style', 'text', 'String', ...
                           ' ', 'Visible', 'off',...
                           'HorizontalAlignment', 'left', 'FontSize', 8, ...
                           'Position', [85 343 87 29], 'BackgroundColor',[0 0 0]);
                       
                this.videoBorder = uicontrol('Parent',this.dayTakeActionPanel, ...
                           'Style', 'text', 'String', ...
                           ' ', 'Visible', 'off',...
                           'HorizontalAlignment', 'left', 'FontSize', 8, ...
                           'Position', [169 343 87 29], 'BackgroundColor',[0 0 0]);
                       
                                     
                % Snapshot Tab (button)                                
                 this.viewSnapshot = uicontrol('Parent', this.dayTakeActionPanel, 'Style', 'pushbutton',...
                           'String', 'Snapshot', 'Position', [3 345 81 25],...
                           'Callback', @this.snapshot_cb, 'BackgroundColor',[.95 .95 .95]);
                       
                % Burst Tab (button)                                 
                 this.viewBurst = uicontrol('Parent', this.dayTakeActionPanel, 'Style', 'pushbutton',...
                           'String', 'Burst', 'Position', [88 345 81 25],...
                           'Callback', @this.burst_cb, 'BackgroundColor',[0.4863 0.72 0.8]);
                       
                % Video Tab (button)                                
                 this.viewVideo = uicontrol('Parent', this.dayTakeActionPanel, 'Style', 'pushbutton',...
                           'String', 'Video', 'Position', [172 345 81 25],...
                           'Callback', @this.video_cb, 'BackgroundColor',[0.4863 0.72 0.8]);
                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                %Snapshot panel
                this.snapshotPanel = uipanel('Visible','on', 'parent', this.dayTakeActionPanel,...
                                           'BackgroundColor',[.8 .81 .9], 'BorderType', 'line',...
                                           'HighlightColor',[0 0 0], 'BorderWidth', 2,...
                                           'Position', [0 .485 1 .25]);
                                       
                       %Save to Specific Folder checkbox (snapshot panel)
                       this.specificSaveCheckBoxSnapshot = uicontrol('Parent', this.snapshotPanel, 'Style',...
                                'checkbox', 'Position', [40 90 15 15], 'Value', 0,...
                                'BackgroundColor',[.8 .81 .9]);

                       %label of Save to specific folder (snapshot panel)  
                       uicontrol('Parent',this.snapshotPanel, ...
                                   'Style', 'text', 'String', ...
                                   '  Save to Specific Folder', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 7.5, ...
                                   'Position', [60 91 150 13], 'BackgroundColor',[.8 .81 .9]);

                       %Save to specific folder edit box                                
                       this.specificSaveEditBoxSnapshot = uicontrol('Parent', this.snapshotPanel, 'Style', 'edit',...
                                   'Position', [10 61 235 25]);
                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                %Burst panel
                this.burstPanel = uipanel('Visible','off', 'parent', this.dayTakeActionPanel,...
                                           'BackgroundColor',[.8 .84 .9], 'BorderType', 'line',...
                                           'HighlightColor',[0 0 0], 'BorderWidth', 2,...
                                           'Position', [0 .485 1 .25]);
          
                        % Title Capture Series Conditions  (burst panel)
                        uicontrol('Parent',this.burstPanel, ...
                                   'Style', 'text', 'String', ...
                                   'Capture Series Conditions:', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 8, ...
                                   'Position', [13 95 150 16], 'BackgroundColor',[.8 .84 .9]);

                         %Capture Series Options panel. (burst panel)      
                         captureSeriesOptionsPanelBurst = uipanel('Parent',this.burstPanel, ...
                                               'BackgroundColor',[.9 .9 .9],...
                                               'BorderType', 'line',...
                                               'HighlightColor', [1 0 0],...
                                               'Position', [.05 .56 .91 .26]);

                                %Capture Series COnditions text (burst panel)
                                uicontrol('Parent', captureSeriesOptionsPanelBurst, ...
                                           'Style', 'text', 'String', ...
                                           'frames captured in            seconds', ...
                                           'HorizontalAlignment', 'center', 'FontSize', 8, ...
                                           'Position', [41 5 170 15], 'BackgroundColor',[.9 .9 .9]);

                                % The capture Series frame number edit box (burst)                                 
                                 this.captureSeriesFrameNumberEditBurst = uicontrol('Parent', captureSeriesOptionsPanelBurst, 'Style', 'edit',...
                                           'Position', [8 2 30 25]);

                                % The capture Series time number edit box   (burst)                              
                                 this.captureSeriesTimeNumberEditBurst = uicontrol('Parent', captureSeriesOptionsPanelBurst, 'Style', 'edit',...
                                           'Position', [136 2 30 25]);
   
                       %Save to Specific Folder checkbox (Burst panel)
                       this.specificSaveCheckBoxBurst = uicontrol('Parent', this.burstPanel, 'Style',...
                                'checkbox', 'Position', [40 42 15 15], 'Value', 0,...
                                'BackgroundColor',[.8 .84 .9]);

                       %label of Save to specific folder (Burst panel)  
                       uicontrol('Parent',this.burstPanel, ...
                                   'Style', 'text', 'String', ...
                                   '  Save to Specific Folder', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 7.5, ...
                                   'Position', [60 41 150 13], 'BackgroundColor',[.8 .84 .9]);

                       %Save to specific folder edit box (Burst panel)                               
                       this.specificSaveEditBoxBurst = uicontrol('Parent', this.burstPanel, 'Style', 'edit',...
                                   'Position', [10 11 235 25]);
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                       
                %Video panel
                this.videoPanel = uipanel('Visible','off', 'parent', this.dayTakeActionPanel,...
                                           'BackgroundColor',[.8 .87 .9], 'BorderType', 'line',...
                                           'HighlightColor',[0 0 0], 'BorderWidth', 2,...
                                           'Position', [0 .485 1 .25]);
                                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                       
                %Message board panel
                this.messageBoardPanel = uipanel('Title', 'Message Board', 'parent', this.dayTakeActionPanel,...
                                           'BackgroundColor',[.8 .81 .9], 'BorderType', 'line',...
                                           'HighlightColor',[0 0 0], 'BorderWidth', 2,...
                                           'Position', [0 0 1 .22]);
                                       
                        %Text of Message Board
                        this.messageBoardText = uicontrol('Parent',this.messageBoardPanel, ...
                                   'Style', 'text', 'String', ...
                                   ' ', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 8, ...
                                   'Position', [1 35 250 45], 'BackgroundColor',[.8 .81 .9]);
                               
                        % Overwrite scheduling conflicts button                              
                         this.overwriteButton = uicontrol('Parent', this.messageBoardPanel, 'Style', 'pushbutton',...
                                   'String', 'Overwrite', 'Position', [20 5 80 25],...
                                   'Callback', @this.overwriteEvents_cb, 'BackgroundColor',[0.4863 0.72 0.8],...
                                   'Visible', 'off');
                               
                        % Cancel current event creation                            
                         this.cancelButton = uicontrol('Parent', this.messageBoardPanel, 'Style', 'pushbutton',...
                                   'String', 'Cancel', 'Position', [150 5 80 25],...
                                   'Callback', @this.cancelOverwriteEvents_cb, 'BackgroundColor',[0.4863 0.72 0.8],...
                                   'Visible', 'off');
                               
                               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                               
                    %Start time Title text label
                    uicontrol('Parent', this.dayTakeActionPanel, 'Style',...
                                   'text', 'String','Start Time:', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 10, ...
                                   'Position', [14 195 70 18], 'BackgroundColor',[.95 .95 .95]);
                               
                               
                    %Start time panel (for aesthetics)      
                    startTimePanel = uipanel('Parent',this.dayTakeActionPanel, ...
                                           'BackgroundColor',[1 1 1],...
                                           'BorderType', 'line',...
                                           'HighlightColor', [1 0 0],...
                                           'Position', [.33 .41 .65 .058]);
                                       
                            %start time semicolon text
                            uicontrol('Parent', startTimePanel, ...
                                       'Style', 'text', 'String', ...
                                       ':', ...
                                       'HorizontalAlignment', 'left', 'FontSize', 10, ...
                                       'Position', [54 5 10 20], 'BackgroundColor',[1 1 1]);
                                   
                            % start time hour condition pop up                               
                            this.startTimeHourPopUp = uicontrol('Parent', startTimePanel,...
                                'Style', 'popup', 'FontSize', 10, 'String',...
                                '12|1|2|3|4|5|6|7|8|9|10|11','Value', 2,...
                                'BackgroundColor',[1 1 1], 'Position', [3 4 50 22]);
                               
                            % start time minute condition pop up                             
                            this.startTimeMinutePopUp = uicontrol('Parent', startTimePanel,...
                                'Style', 'popup', 'FontSize', 10, 'String', ...
                                '00|10|20|30|40|50','Value', 2,...
                                'BackgroundColor',[1 1 1], 'Position', [62 4 50 22]);
                           
                            % start time am pm condition pop up                             
                            this.startTimeAmPmPopUp = uicontrol('Parent', startTimePanel, 'Style', 'popup',...
                               'FontSize', 10, 'String', 'am|pm','Value', 2,...
                               'BackgroundColor',[1 1 1], 'Position', [113 4 50 22]);
                           
                           
                    %Repeat text label
                    uicontrol('Parent', this.dayTakeActionPanel, 'Style',...
                                   'text', 'String','Repeat:', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 10, ...
                                   'Position', [14 160 50 18], 'BackgroundColor',[.95 .95 .95]);

                    %Repeat selection panel (for aesthetics)      
                    repeatSelectionPanel = uipanel('Parent',this.dayTakeActionPanel, ...
                                           'BackgroundColor',[1 1 1],...
                                           'BorderType', 'line',...
                                           'HighlightColor', [1 0 0],...
                                           'Position', [.27 .34 .60 .052]);
                                       
                             %Repeat Action TRUE OR FLASE text box                             
                             this.repeatActionSelectionText = uicontrol('Parent', repeatSelectionPanel, ...
                                    'Style', 'text', 'String', 'NONE', 'FontSize', 10, ...
                                    'FontWeight', 'bold', 'ForegroundColor', 'red', ...
                                    'Position', [12 1 50 20],'BackgroundColor',[1 1 1]);
                                
                            % Repeatoptions expand button                              
                            uicontrol('Parent', repeatSelectionPanel, 'Style', 'pushbutton',...
                                       'String', 'Options', 'Position', [75 2 70 21],...
                                       'Callback', @this.repeatOptionsExpand_cb, 'BackgroundColor',[0.863 0.72 0.8]);

                                
                    % Create Event Button                               
                    uicontrol('Parent', this.dayTakeActionPanel, 'Style', 'pushbutton',...
                               'String', 'Create', 'Position', [163 105 80 25],...
                               'Callback', @this.createEventButtonHit_cb, 'BackgroundColor',[0.4863 0.72 0.8]);
        end

        %Specific event info panel build
        function specificEventInfoPanelBuild(this, structInfo)
            
            this.specificEventStructToBeAltered = structInfo;
            
            eventID = this.specificEventStructToBeAltered.eventID;
            dateIDstart = this.specificEventStructToBeAltered.dateIDstart;
            startTime = this.specificEventStructToBeAltered.startTime;
            dateIDend = this.specificEventStructToBeAltered.dateIDend;
            endTime = this.specificEventStructToBeAltered.endTime;
            cameraID = this.specificEventStructToBeAltered.cameraID;
            action = this.specificEventStructToBeAltered.action;
            repeatFrequency = this.specificEventStructToBeAltered.repeatFrequency;
            repeatOccurences = this.specificEventStructToBeAltered.repeatOccurences;
            
            %Specific Event Info Panel (SeIp)
            this.specificEventInfoPanel = uipanel('BackgroundColor',[.95 .95 .95], 'BorderType', 'line',...
                       'HighlightColor',[0 0 1], 'BorderWidth', 2,'Position', [.72 .01 .27 .87],...
                       'Visible', 'on');
                   
                    %View or edit event title
                    uicontrol('Parent', this.specificEventInfoPanel, 'Style',...
                                   'text', 'String','View/Delete Event', 'FontWeight', 'bold', ...
                                   'HorizontalAlignment', 'center', 'FontSize', 14, ...
                                   'Position', [38 435 190 25], 'BackgroundColor',[.95 .95 .95]);
                               
                    if repeatOccurences == 0
                        eventOriginalNote = 'This is not part of a repeat series';

                    else
                        eventOriginalNote = 'This is part of a repeat series';
                    end        
                               
                    %View or edit event title
                    uicontrol('Parent', this.specificEventInfoPanel, 'Style',...
                                   'text', 'String',eventOriginalNote, 'ForegroundColor', 'red',...
                                   'HorizontalAlignment', 'center', 'FontSize', 10, ...
                                   'Position', [38 400 190 25], 'BackgroundColor',[.95 .95 .95]);
                               
                    % Close Event View panel Button                               
                    uicontrol('Parent', this.specificEventInfoPanel, 'Style', 'pushbutton',...
                               'String', 'X', 'Position', [232 444 20 20],...
                               'Callback', @this.closeEventPanel_cb, 'BackgroundColor',[0.4863 0.72 0.8]);
            
            infoLabelEv = {'', 'Start Date:','Start Time:','End Date:','End Time:','Camera:','Action:','Repeat Fr:','Repeat Occ:'};
            infoDataEv = {eventID,dateIDstart,startTime,dateIDend,endTime,cameraID,action,repeatFrequency,repeatOccurences};

            for x = 1:1:9
                
                if x == 1 % eventID needs a longer div
                    descriptionPositionXstart = 1;
                    labelXstretch = 1;
                    panelXstretch = .98;
                    panelXstart = .01;
                    controlXstretch = 234;
                else
                    descriptionPositionXstart = 10;
                    labelXstretch = 80;
                    panelXstart = .4;
                    panelXstretch = .32;
                    controlXstretch = 65;
                end

                %Info Label and position
                yDropInfoLabel = 380 - ( (x-1) * 29 );
                uicontrol('Parent', this.specificEventInfoPanel, 'Style',...
                               'text', 'String',infoLabelEv(x), ...
                               'HorizontalAlignment', 'left', 'FontSize', 10, ...
                               'Position', [14 yDropInfoLabel labelXstretch 18], 'BackgroundColor',[.95 .95 .95]);
                 
                 %Info panel (for aesthetics) and positioning
                 yDropDataLabel = .81 - ( (x-1) * .062 );
                 tempUIpanel2 = uipanel('Parent',this.specificEventInfoPanel, ...
                                       'BackgroundColor',[1 1 1],...
                                       'BorderType', 'line',...
                                       'HighlightColor', [1 0 0],...
                                       'Position', [panelXstart yDropDataLabel panelXstretch .037]);

                         %Info description edit text box                                 
                         uicontrol('Parent', tempUIpanel2, 'Style',...
                                   'text', 'String', infoDataEv(x), 'FontSize', 10, ...
                                   'Position', [descriptionPositionXstart 2 controlXstretch 14], 'BackgroundColor',[1 1 1]); 
            end
                
                % Delete Event Button                               
                uicontrol('Parent', this.specificEventInfoPanel, 'Style', 'pushbutton',...
                               'String', 'Delete', 'Position', [163 105 80 25],...
                               'Callback', @this.deleteEventButtonHit_cb, 'BackgroundColor',[0.4863 0.72 0.8]);
                           
                %Message board panel for Repeat options
                this.messageBoardSpecificEventPanel = uipanel('Title', 'Message Board', 'parent', this.specificEventInfoPanel,...
                                           'BackgroundColor',[.8 .81 .9], 'BorderType', 'line',...
                                           'HighlightColor',[0 0 0], 'BorderWidth', 2,...
                                           'Position', [0 0 1 .22], 'Visible', 'off');
                                       
                        %Text of Message Board
                        this.messageBoardSpecificText = uicontrol('Parent',this.messageBoardSpecificEventPanel, ...
                                   'Style', 'text', 'String', ...
                                   ' ', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 8, ...
                                   'Position', [1 35 250 45], 'BackgroundColor',[.8 .81 .9]);
                               
                        % Delete confirmation for repeat button (Deletes all in repeat series)                              
                        uicontrol('Parent', this.messageBoardSpecificEventPanel, 'Style', 'pushbutton',...
                                   'String', 'Delete All', 'Position', [20 5 80 25],...
                                   'Callback', @this.deleteAllEventsButtonHit_cb, 'BackgroundColor',[0.4863 0.72 0.8]);
                               
                        % Delete Single for repeat button (Deletes                      
                         uicontrol('Parent', this.messageBoardSpecificEventPanel, 'Style', 'pushbutton',...
                                   'String', 'Delete Single', 'Position', [150 5 80 25],...
                                   'Callback', @this.deleteSingleEventButtonHit_cb, 'BackgroundColor',[0.4863 0.72 0.8]);
        end
        
        %Repeat options panel build
        function repeatOptionsPanelBuild(this)

            %repeatOptionsPanel (RoP)
            this.repeatOptionsPanel = uipanel('BackgroundColor',[.95 .95 .95], 'BorderType', 'line',...
                       'HighlightColor',[0 0 1], 'BorderWidth', 2, 'Units', 'pixels',...
                       'Position', [691 213 259 262],...
                       'Visible', 'off');
                   
                    %Repeat options title
                    uicontrol('Parent', this.repeatOptionsPanel, 'Style',...
                                   'text', 'String','Repeat Options', 'FontWeight', 'bold', ...
                                   'HorizontalAlignment', 'center', 'FontSize', 14, ...
                                   'Position', [37 212 190 25], 'BackgroundColor',[.95 .95 .95]);
 
                    uicontrol('Parent', this.repeatOptionsPanel, 'Style',...
                                   'text', 'String','Repeat every:', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 10, ...
                                   'Position', [10 170 90 18], 'BackgroundColor',[.95 .95 .95]);

                     tempUIpanel4 = uipanel('Parent',this.repeatOptionsPanel, ...
                                           'BackgroundColor',[1 1 1],...
                                           'BorderType', 'line',...
                                           'HighlightColor', [1 0 0],...
                                           'Units', 'pixels', ...
                                           'Position', [100 165 149 30]);
                                       
                               % number for repeat frequency (to be paired with word like 2 weeks)                                
                               this.numberRepeatFrequencyRoP = uicontrol('Parent', tempUIpanel4, 'Style', 'edit',...
                                           'Position', [2 2 50 25]);

                              % string for repeat frequency factor (to be paired with number like 2 weeks)                              
                              this.stringRepeatFrequencyPopUpBoxRoP = uicontrol('Parent', tempUIpanel4, 'Style',...
                                         'popup', 'String', 'minute(s)|hour(s)|day(s)|week(s)|month(s)|year(s)', 'FontSize', 10, ...
                                         'Position', [55 2 92 25], 'BackgroundColor',[1 1 1]); 
                                   
                    uicontrol('Parent', this.repeatOptionsPanel, 'Style',...
                                   'text', 'String','Ends after:', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 10, ...
                                   'Position', [10 137 90 18], 'BackgroundColor',[.95 .95 .95]);

                     tempUIpanel6 = uipanel('Parent',this.repeatOptionsPanel, ...
                                           'BackgroundColor',[1 1 1],...
                                           'BorderType', 'line',...
                                           'HighlightColor', [1 0 0],...
                                           'Units', 'pixels', ...
                                           'Position', [100 132 149 30]);
                                       
                               % number for repeat frequency (to be paired with word like 2 weeks)                            
                               this.numberRepeatTotalOccurencesRoP = uicontrol('Parent', tempUIpanel6, 'Style', 'edit',...
                                           'Position', [2 2 50 25]);
                                       
                               % occurence label text                               
                               uicontrol('Parent', tempUIpanel6, 'Style', 'text',...
                                           'String', 'Occurences', 'Position', [54 1 80 20],...
                                           'BackgroundColor',[1 1 1]);

                % Cancel Repeat Request Button
                uicontrol('Parent', this.repeatOptionsPanel, 'Style', 'pushbutton',...
                               'String', 'Cancel', 'Position', [133 90 80 25],...
                               'Callback', @this.cancelRepeatRequest_cb, 'BackgroundColor',[0.4863 0.72 0.8]);
                           
                % Submit Repeat Request Button                          
                uicontrol('Parent', this.repeatOptionsPanel, 'Style', 'pushbutton',...
                               'String', 'Submit', 'Position', [40 90 80 25],...
                               'Callback', @this.submitRepeatRequest_cb, 'BackgroundColor',[0.4863 0.72 0.8]);
                           
                %Message board panel for Repeat options
                this.messageBoardRepeatOptionsPanel = uipanel('Title', 'Message Board', 'parent', this.repeatOptionsPanel,...
                                           'BackgroundColor',[.8 .81 .9], 'BorderType', 'line',...
                                           'HighlightColor',[1 0 0], 'BorderWidth', 2, 'Units', 'pixels',...
                                           'Position', [2 2 254 67], 'Visible', 'on');
                                       
                        %Text of Message Board
                        this.messageBoardRepeatOptionsText = uicontrol('Parent',this.messageBoardRepeatOptionsPanel, ...
                                   'Style', 'text', 'String', ...
                                   ' ', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 8, ...
                                   'Position', [1 1 248 53], 'BackgroundColor',[.8 .81 .9]);
        end
        
        %Repeat options button hit
        function repeatOptionsExpand_cb(this,~,~) 
            
           set(this.specificEventInfoPanel, 'Visible', 'off');
           set(this.dayTakeActionPanel, 'Visible', 'off');
           set(this.repeatOptionsPanel, 'Visible', 'on');

        end
        
        %Cancel Repeat request button hit
        function cancelRepeatRequest_cb(this,~,~)
            
            this.repeatFrequencyNumber = 0; 
            this.repeatTotalOccurenceNumber = 0; 
            set(this.repeatActionSelectionText, 'ForegroundColor', 'red');
            set(this.repeatOptionsPanel, 'Visible', 'off');
            set(this.specificEventInfoPanel, 'Visible', 'off');
            set(this.dayTakeActionPanel, 'Visible', 'on');
            set(this.repeatActionSelectionText, 'String', 'NONE');
            
            set(this.messageBoardText, 'ForegroundColor', [0 .6 0]);
            set(this.messageBoardText, 'String', 'Repeat conditions successfully CANCELLED!');

        end
        
        %submit Repeat request button hit
        function submitRepeatRequest_cb(this,~,~)

            repeatFrequencyStringIncomplete = get(this.numberRepeatFrequencyRoP, 'String');
            repeatFrequencyNumberIncomplete = str2num(repeatFrequencyStringIncomplete); 
            
            repeatFrequencyFactorPullDownIndex = get(this.stringRepeatFrequencyPopUpBoxRoP, 'Value');
           
            repeatTotalOccuranceStringIncomplete = get(this.numberRepeatTotalOccurencesRoP, 'String');
            this.repeatTotalOccurenceNumber = str2num(repeatTotalOccuranceStringIncomplete); 
            
            %we want the frequency in terms of once every X minutes
            if repeatFrequencyFactorPullDownIndex == 1
                repeatFrequencyFactor = 1;
            elseif repeatFrequencyFactorPullDownIndex == 2
                repeatFrequencyFactor = 60; %hour
            elseif repeatFrequencyFactorPullDownIndex == 3
                repeatFrequencyFactor = 60*24; %day
            elseif repeatFrequencyFactorPullDownIndex == 1
                repeatFrequencyFactor = 60*24*7; %week
            elseif repeatFrequencyFactorPullDownIndex == 1
                repeatFrequencyFactor = 60*24*30; %Months are 30 days. This might have to change
            elseif repeatFrequencyFactorPullDownIndex == 1
                repeatFrequencyFactor = 60*24*365; %Years are 365 days. This might have to change
            end

            this.repeatFrequencyNumber = repeatFrequencyFactor * repeatFrequencyNumberIncomplete;
            
            %Do logic check to see if inputs were ok.
            
            %If inputs ok we need to set those repeat variables and we need
            %to change the message board panel and repeat string
            
            %The logic check for if there are conflicting events takes place in createEvent_cb.
            
            %The logic check for if the repeat interval is shorter than the
            %duration of burst or video will also take place in createEvent_cb

            set(this.repeatOptionsPanel, 'Visible', 'off');
            set(this.specificEventInfoPanel, 'Visible', 'off');
            set(this.dayTakeActionPanel, 'Visible', 'on');
            set(this.repeatActionSelectionText, 'ForegroundColor', [0 .6 0]);
            set(this.repeatActionSelectionText, 'String', 'SET');
            
            set(this.messageBoardText, 'ForegroundColor', [0 .6 0]);
            set(this.messageBoardText, 'String', 'Repeat conditions successfully SET!');
        end  

        %Delete event button hit
        function deleteEventButtonHit_cb(this,~,~) 
            
            %If event is NOT in a repeat series we can go ahead and delete
            if this.specificEventStructToBeAltered.repeatOccurences == 0
                this.deleteEvent; 
                set(this.messageBoardText, 'ForegroundColor', [0 .6 0]);
                set(this.messageBoardText, 'String', 'Event successfully deleted!');
                
            %If event IS in a repeat series, we need confirmation
            else
                set(this.messageBoardSpecificEventPanel, 'Visible', 'on');
                set(this.messageBoardSpecificText, 'ForegroundColor', 'red');
                set(this.messageBoardSpecificText, 'String', 'This event is part of a repeat series. Would you like to delete them all or just this event?');
            end
        end
        
        %Confirm deletion of all events in repeat series button hit
        function deleteAllEventsButtonHit_cb(this,~,~) 

            this.deleteEvent;
            set(this.messageBoardSpecificEventPanel, 'Visible', 'off');
            set(this.messageBoardText, 'ForegroundColor', [0 .6 0]);
            set(this.messageBoardText, 'String', 'All events in repeat series have been deleted');
        end
        
        %Delete single and leave the rest of the repeat series alone
        function deleteSingleEventButtonHit_cb(this,~,~) 
        % Here we will split the repeat series at the deletion point and create a new series with the 2nd group. We are NOT deleting anything in 
        % reality. We are either altering an existing event or altering and creating events. So we never get into Delete event function in this class
        
            cla(this.patchWorkView.dayAxisWithData);

            %load data file 
            load('ScheduleDataFile6.mat');
            
            %Get datenumber of current event not initial event;
            dateNumOfCurrentEventStart = this.specialToolsInstance.getDateWithTimeNumber(this.specificEventStructToBeAltered.startTime, this.specificEventStructToBeAltered.dateIDstart);
            dateNumOfCurrentEventEnd = this.specialToolsInstance.getDateWithTimeNumber(this.specificEventStructToBeAltered.endTime, this.specificEventStructToBeAltered.dateIDend);
            
            % Get datenumber of initial event of repeat series;
            dateNumberofOriginalEventStart = this.specialToolsInstance.geDateNumberFromEventID(this.specificEventStructToBeAltered.eventID);
            dateNumberofOriginalEventEnd = dateNumberofOriginalEventStart + (dateNumOfCurrentEventEnd - dateNumOfCurrentEventStart);
            
            % Repeat number index does not include original event. So index of 2 would be the 3rd of the group.
            repeatNumberIndex = round((dateNumOfCurrentEventStart - dateNumberofOriginalEventStart) / (this.specificEventStructToBeAltered.repeatFrequency/1440));

            % find index for current event to be deleted
            this.indexNumsOfEventToBeAltered = this.specialToolsInstance.findDesiredIndex(event6, 'eventID', this.specificEventStructToBeAltered.eventID);
            
            if repeatNumberIndex == 0
                xxxRefurbish = 1;
                refurbishEvent = 1;
                createEvent = 0;
                newOccuenceFactorForAltered = round(this.specificEventStructToBeAltered.repeatOccurences - 1);

            elseif this.specificEventStructToBeAltered.repeatOccurences == repeatNumberIndex
                xxxRefurbish = 0;
                refurbishEvent = 1;
                createEvent = 0;
                newOccuenceFactorForAltered = round(this.specificEventStructToBeAltered.repeatOccurences - 1);
                
            elseif repeatNumberIndex > 0 && repeatNumberIndex < this.specificEventStructToBeAltered.repeatOccurences
                xxxRefurbish = 0;
                refurbishEvent = 1;
                createEvent = 1;
                newOccurenceFactorForCreate = round(this.specificEventStructToBeAltered.repeatOccurences - repeatNumberIndex - 1);
                newOccuenceFactorForAltered = round(repeatNumberIndex - 1);
            end    
            
            if refurbishEvent == 1
                this.startDateID2bA = datestr(dateNumberofOriginalEventStart + (xxxRefurbish * this.specificEventStructToBeAltered.repeatFrequency/1440), 'YYYYmmDD');
                this.startTime2bA = datestr(dateNumberofOriginalEventStart + (xxxRefurbish * this.specificEventStructToBeAltered.repeatFrequency/1440), 'HH:MM:SS');
                this.endDateID2bA = datestr(dateNumberofOriginalEventEnd + (xxxRefurbish * this.specificEventStructToBeAltered.repeatFrequency/1440), 'YYYYmmDD');
                this.endTime2bA = datestr(dateNumberofOriginalEventEnd + (xxxRefurbish * this.specificEventStructToBeAltered.repeatFrequency/1440), 'HH:MM:SS');
                this.cameraID2bA = this.specificEventStructToBeAltered.cameraID;
                this.action2bA = this.specificEventStructToBeAltered.action;
                this.repeatTotalOccurenceNumber2bA = newOccuenceFactorForAltered;

                if this.repeatTotalOccurenceNumber2bA == 0 
                    this.repeatFrequencyNumber2bA = 0;
                else
                    this.repeatFrequencyNumber2bA = round(this.specificEventStructToBeAltered.repeatFrequency);
                end
                this.eventID2bA = this.specialToolsInstance.getEventID(this.cameraID2bA, this.startDateID2bA, this.startTime2bA, this.repeatFrequencyNumber2bA, this.repeatTotalOccurenceNumber2bA);
                
                notify(this, 'eventAltered');
            end
            
            if createEvent == 1
                this.startDateID2bC = datestr(dateNumberofOriginalEventStart + ((repeatNumberIndex + 1) * this.specificEventStructToBeAltered.repeatFrequency/1440), 'YYYYmmDD');
                this.startTime2bC = datestr(dateNumberofOriginalEventStart + ((repeatNumberIndex + 1) * this.specificEventStructToBeAltered.repeatFrequency/1440), 'HH:MM:SS');
                this.endDateID2bC = datestr(dateNumberofOriginalEventEnd + ((repeatNumberIndex + 1) * this.specificEventStructToBeAltered.repeatFrequency/1440), 'YYYYmmDD');
                this.endTime2bC = datestr(dateNumberofOriginalEventEnd + ((repeatNumberIndex + 1) * this.specificEventStructToBeAltered.repeatFrequency/1440), 'HH:MM:SS');
                this.cameraID2bC = this.specificEventStructToBeAltered.cameraID;
                this.action2bC = this.specificEventStructToBeAltered.action; 
                this.repeatTotalOccurenceNumber2bC = newOccurenceFactorForCreate;
               
                if this.repeatTotalOccurenceNumber2bC == 0
                    this.repeatFrequencyNumber2bC = 0;
                else
                    this.repeatFrequencyNumber2bC = round(this.specificEventStructToBeAltered.repeatFrequency);
                end
                this.eventID2bC = this.specialToolsInstance.getEventID(this.cameraID2bC, this.startDateID2bC, this.startTime2bC, this.repeatFrequencyNumber2bC, this.repeatTotalOccurenceNumber2bC);
                notify(this, 'eventCreated');
            end
            
            this.patchWorkView = patchBuilderDaySchedule3(this.dayNarrowPanel,this.dataDateID);
            addlistener(this.patchWorkView, 'specificEventClicked', @this.handleSpecificEventClicked);
            set(this.specificEventInfoPanel, 'Visible', 'off');
            set(this.dayTakeActionPanel, 'Visible', 'on');

            %Hide Buttons
            set(this.messageBoardSpecificEventPanel, 'Visible', 'off');
            set(this.messageBoardText, 'ForegroundColor', [0 .6 0]);
            set(this.messageBoardText, 'String', 'This single event has been deleted');
        end
        
        function deleteEvent(this)

            %load data file 
            load('ScheduleDataFile6.mat');
            
            % Find index for current event to be deleted
            this.indexNumsOfEventToBeAltered = this.specialToolsInstance.findDesiredIndex(event6, 'eventID', this.specificEventStructToBeAltered.eventID);
  
            cla(this.patchWorkView.dayAxisWithData)
            notify(this, 'eventDeleted');

            this.patchWorkView = patchBuilderDaySchedule3(this.dayNarrowPanel,this.dataDateID);
            addlistener(this.patchWorkView, 'specificEventClicked', @this.handleSpecificEventClicked);
            set(this.specificEventInfoPanel, 'Visible', 'off');
            set(this.dayTakeActionPanel, 'Visible', 'on')
        end
            
        %Create new event and delete conflicting events
        function overwriteEvents_cb(this,~,~)
            
                %load data file 
                load('ScheduleDataFile6.mat');

                cla(this.patchWorkView.dayAxisWithData);
                
                for x = 1:1:length(this.eventIDsOfConflictingEvents)
                    
                    this.indexNumsOfEventToBeAltered = this.specialToolsInstance.findDesiredIndex(event6, 'eventID', this.eventIDsOfConflictingEvents(x));
                    notify(this, 'eventDeleted');
                end  
               
                notify(this, 'eventCreated');
                
                this.patchWorkView = patchBuilderDaySchedule3(this.dayNarrowPanel,this.dataDateID);
                addlistener(this.patchWorkView, 'specificEventClicked', @this.handleSpecificEventClicked);
                set(this.specificEventInfoPanel, 'Visible', 'off');
                set(this.dayTakeActionPanel, 'Visible', 'on');
                    
                set(this.messageBoardText, 'ForegroundColor', [0 .6 0]);
                set(this.overwriteButton, 'Visible', 'off');
                set(this.cancelButton, 'Visible', 'off');
                set(this.messageBoardText, 'String', 'Event creation and event overwrites successful!');
        end
        
        %cancel event creation and do not overwrite conflicting events
        function cancelOverwriteEvents_cb(this,~,~)
            
                set(this.messageBoardText, 'ForegroundColor', [0 .6 0]);
                set(this.overwriteButton, 'Visible', 'off');
                set(this.cancelButton, 'Visible', 'off');
                set(this.messageBoardText, 'String', 'Event creation successfully cancelled');

        end
        
        %Create event button hit
        function createEventButtonHit_cb(this,~,~)
            
            % Reset conflicting events to empty
            this.eventIDsOfConflictingEvents = {};
            
            %Loads the data file with all prior scheduled events
            load('ScheduleDataFile6.mat');
            
            % Camera ID
            cameraIDStringfull = cellstr(get(this.eventCameraSelectionPopUpBox, 'String'));
            cameraID = char(cameraIDStringfull(get(this.eventCameraSelectionPopUpBox, 'Value')));
            this.cameraID2bC = cameraID;

            %If no camera was selected logic check
            if strcmp(cameraID, 'Please Select') == 1
                set(this.messageBoardText, 'ForegroundColor', 'red');
                set(this.messageBoardText, 'String', 'Please select a camera.');
                return
            end
          
            % Here we will do a logic check for folder directory 

        % START time string ('mm:dd:ss') and datenum with seconds for prospective event
            
            % Hour String and Variable
            startTimeHourPopUpStringfull = cellstr(get(this.startTimeHourPopUp, 'String'));
            startTimeHourPopUpString = char(startTimeHourPopUpStringfull(get(this.startTimeHourPopUp, 'Value')));
            amPmPopUpStringfull = cellstr(get(this.startTimeAmPmPopUp, 'String'));
            amPmPopUpString = char(amPmPopUpStringfull(get(this.startTimeAmPmPopUp, 'Value')));
            [~, strStartTimeInputNewEventHOUR] = this.specialToolsInstance.TwelveHourFormatTo24HourFormatHOUR(startTimeHourPopUpString, amPmPopUpString);

            %Minute string
            strStartTimeInputNewEventMINfull = cellstr(get(this.startTimeMinutePopUp, 'String'));
            strStartTimeInputNewEventMIN = char(strStartTimeInputNewEventMINfull(get(this.startTimeMinutePopUp, 'Value')));

            %Second string
            strStartTimeInputNewEventSEC = '00';

            %Start time in string format 'hh:mm:ss'
            this.startTime2bC = strcat(strStartTimeInputNewEventHOUR,':',strStartTimeInputNewEventMIN,':',strStartTimeInputNewEventSEC);
            
            % Start time in datenum with seconds format
            dateNumForProspectiveEventStartTimeINITIAL = this.specialToolsInstance.getDateWithTimeNumber(this.startTime2bC, this.dataDateID);        
            
        % END time string ('mm:dd:ss') and datenum with seconds for prospective event   
            
            % Snapshot mode
            if strcmp(get(this.snapshotBorder,'Visible') , 'on') == 1
                varDelay = 5; % We'll just give snapshots 5 seconds
                this.action2bC = 'Still';

            % Burst Mode
            elseif strcmp(get(this.burstBorder,'Visible') , 'on') == 1
                strDelay = get(this.captureSeriesTimeNumberEditBurst, 'String');
                %Here we will do a logic check to make sure burst inputs are ok
                varDelay = str2num(strDelay);
                this.action2bC = 'Burst';

            %Video Mode   
            elseif strcmp(get(this.videoBorder,'Visible') , 'on') == 1
                %Here we will do a logic check to make sure video inputs are ok
                this.action2bC = 'Video';
            end

            % End time in datenum with seconds format
            dateNumForProspectiveEventEndTimeINITIAL = dateNumForProspectiveEventStartTimeINITIAL + (varDelay/86400);
            
            %End time in string format 'hh:mm:ss'
            this.endTime2bC = datestr(dateNumForProspectiveEventEndTimeINITIAL, 'HH:MM:SS');
            
         % SCHEDULE CHECK
         
            %Check for conflicts. will return 1 for yes conflicts or 0 for no conflicts
            conflictResult = this.eventsConflictChecker(event6, this.cameraID2bC, dateNumForProspectiveEventStartTimeINITIAL, dateNumForProspectiveEventEndTimeINITIAL, this.repeatFrequencyNumber, this.repeatTotalOccurenceNumber);
     
            this.startDateID2bC = datestr(dateNumForProspectiveEventStartTimeINITIAL, 'YYYYmmDD');
            this.endDateID2bC = datestr(dateNumForProspectiveEventEndTimeINITIAL, 'YYYYmmDD');
            this.repeatFrequencyNumber2bC = this.repeatFrequencyNumber;
            this.repeatTotalOccurenceNumber2bC = this.repeatTotalOccurenceNumber;
            this.eventID2bC = this.specialToolsInstance.getEventID(this.cameraID2bC, this.startDateID2bC, this.startTime2bC, this.repeatFrequencyNumber2bC, this.repeatTotalOccurenceNumber2bC);
            
            if conflictResult == 0

                cla(this.patchWorkView.dayAxisWithData);
                notify(this, 'eventCreated');

                this.patchWorkView = patchBuilderDaySchedule3(this.dayNarrowPanel,this.dataDateID);
                addlistener(this.patchWorkView, 'specificEventClicked', @this.handleSpecificEventClicked);
                            
            else
                set(this.messageBoardText, 'ForegroundColor', 'red');
                set(this.overwriteButton, 'Visible', 'on');
                set(this.cancelButton, 'Visible', 'on');
                set(this.messageBoardText, 'String', 'This camera has one or more scheduling conflicts. Would you like to overwrite any conflicting events and any subsequent repeat events?');  
            end
        end

        %Close event panel button hit
        function closeEventPanel_cb(this,~,~)

            set(this.specificEventInfoPanel, 'Visible', 'off');
            set(this.dayTakeActionPanel, 'Visible', 'on');

        end
        
        %The snapshot tab has been clicked
        function snapshot_cb(this,~,~)
            
            set(this.snapshotBorder,'Visible','on');
            set(this.burstBorder,'Visible','off');
            set(this.videoBorder,'Visible','off');
            
            set(this.viewSnapshot,'BackgroundColor',[.95 .95 .95]);
            set(this.viewBurst,'BackgroundColor',[0.4863 0.72 0.8]);
            set(this.viewVideo,'BackgroundColor',[0.4863 0.72 0.8]);

            set(this.snapshotPanel,'Visible','on');
            set(this.burstPanel,'Visible','off');
            set(this.videoPanel,'Visible','off');
            
            set(this.messageBoardPanel,'BackgroundColor',[.8 .81 .9]);
            set(this.messageBoardText,'BackgroundColor',[.8 .81 .9]);
            
            %This just erases the message board
            set(this.messageBoardText, 'String', ' ');
            
        end
        
        %the burst tab has been clicked
        function burst_cb(this,~,~)
            
            set(this.snapshotBorder,'Visible','off');
            set(this.burstBorder,'Visible','on');
            set(this.videoBorder,'Visible','off');
            
            set(this.viewSnapshot,'BackgroundColor',[0.4863 0.72 0.8]);
            set(this.viewBurst,'BackgroundColor',[.9 .9 .9]);
            set(this.viewVideo,'BackgroundColor',[0.4863 0.72 0.8]); 
            
            set(this.snapshotPanel,'Visible','off');
            set(this.burstPanel,'Visible','on');
            set(this.videoPanel,'Visible','off');
            
            set(this.messageBoardPanel,'BackgroundColor',[.8 .84 .9]);
            set(this.messageBoardText,'BackgroundColor',[.8 .84 .9]);
            
            %This just erases the message board
            set(this.messageBoardText, 'String', ' ');
            
        end
        
        %The video tab has been clicked
        function video_cb(this,~,~)
            
            set(this.snapshotBorder,'Visible','off');
            set(this.burstBorder,'Visible','off');
            set(this.videoBorder,'Visible','on');
            
            set(this.viewSnapshot,'BackgroundColor',[0.4863 0.72 0.8]);
            set(this.viewBurst,'BackgroundColor',[0.4863 0.72 0.8]);
            set(this.viewVideo,'BackgroundColor',[.85 .85 .85]);
            
            set(this.snapshotPanel,'Visible','off');
            set(this.burstPanel,'Visible','off');
            set(this.videoPanel,'Visible','on');
            
            set(this.messageBoardPanel,'BackgroundColor',[.8 .87 .9]);
            set(this.messageBoardText,'BackgroundColor',[.8 .87 .9]);
            
            %This just erases the message board
            set(this.messageBoardText, 'String', ' ');
            
        end

        function handleSpecificEventClicked(this,src,evt)

            set(this.specificEventInfoPanel, 'Visible', 'off');
            set(this.dayTakeActionPanel, 'Visible', 'off');
            set(this.repeatOptionsPanel, 'Visible', 'off');

            this.specificEventInfoPanelBuild(src.camClickedStruct);
        end
        
        %Checks event against enitre structure
        function conflictResult = eventsConflictChecker(this, totalEventsStruct, cameraID_PE, dateNumForProspectiveEventStartTimeINITIAL, dateNumForProspectiveEventEndTimeINITIAL, repeatFrequency_PE, repeatOccurences_PE)
            
        %totalEventsStruct: Structure with all of the events

            %Finds the total number of events in the calender 
            [~, totalEventsNumber] = size(totalEventsStruct);
            
            conflictResult = 0;
            
            for x = 1:1:totalEventsNumber

                dateNumForloopingEventStartTimeINITIAL = this.specialToolsInstance.getDateWithTimeNumber(totalEventsStruct(x).startTime, totalEventsStruct(x).dateIDstart);
                dateNumForloopingEventEndTimeINITIAL = this.specialToolsInstance.getDateWithTimeNumber(totalEventsStruct(x).endTime, totalEventsStruct(x).dateIDend);
                
                loopEventRepeatFrequency = totalEventsStruct(x).repeatFrequency;
                
                % If the camera of the current FOR loop event = camera of event attempting creation
                if strcmp(totalEventsStruct(x).cameraID , cameraID_PE) == 1
                    
                    for xx = 0:1:totalEventsStruct(x).repeatOccurences

                        for xxx = 0:1:repeatOccurences_PE

                            % Compare timing: We have a conflict
                            if (dateNumForloopingEventStartTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)) <= (dateNumForProspectiveEventEndTimeINITIAL  + (repeatFrequency_PE/1440*xxx)) && ... 
                                (dateNumForloopingEventEndTimeINITIAL + (loopEventRepeatFrequency/1440 * xx)) >= (dateNumForProspectiveEventStartTimeINITIAL + (repeatFrequency_PE/1440*xxx))

                                conflictResult = 1;
                                this.eventIDsOfConflictingEvents{end+1} = totalEventsStruct(x).eventID;

                            end
                        end
                    end
                end
            end
        end
                      
        function delete(this)
            % disp('SchedDayClass7 delete')
            delete(this.patchWorkView);
        end
    end
end