classdef  ViewOptionsClass4 < handle            

    properties (SetAccess = public)

        hFig;
           
        view1optionsPanel;
        view1Tbox;
        view1CurrentCamLabelTbox;
        view1CurrentCamActualTbox;

        snapshotBorder;
        burstBorder;
        videoBorder;
        
        viewSnapshot;
        viewBurst;
        viewVideo;
        
        messageBoardPanel;
            messageBoardText;
        
        snapshotPanel;
            specificSaveCheckBoxSnapshot;
            specificSaveLabelTBoxSnapshot;
            specificSaveEditBoxSnapshot;
            captureFrameSnapshot;
            saveOptionsTBoxSnapshot;
            saveOptionsPanelSnapshot;
                previewCheckBoxSnapshot;
                previewLabelTBoxSnapshot;
                saveCheckBoxSnapshot;
                saveLabelTBoxSnapshot;
                
        burstPanel;
            captureSeriesConditionsTitleTboxBurst;
            captureSeriesOptionsPanelBurst;
                captureSeriesConditionsLabelTboxBurst;
                captureSeriesFrameNumberEditBurst;
                captureSeriesTimeNumberEditBurst;
            specificSaveCheckBoxBurst;
            specificSaveLabelTBoxBurst;
            specificSaveEditBoxBurst;
            captureSeriesBurst;
            saveOptionsTBoxBurst;
            saveOptionsPanelBurst;
                previewCheckBoxBurst;
                previewLabelTBoxBurst;
                saveCheckBoxBurst;
                saveLabelTBoxBurst;
        
        videoPanel;

        viewOptionX;
        cameraNumberX
           
    end     
    
    events
        captureFrame;
        captureSeries;
    end

    methods
        function this = ViewOptionsClass4(hFig, viewOption, cameraNumber)
            
            this.viewOptionX = viewOption;
            this.cameraNumberX = cameraNumber;
            
            if this.viewOptionX == 1
                panelCoords = [.31 .52 .20 .44];
                viewTitle = '  View 1 Options Panel';
            elseif this.viewOptionX == 2
                panelCoords = [.31 .02 .20 .44];
                viewTitle = '  View 2 Options Panel';
            end
            
            %View 1 Options panel.      
            this.view1optionsPanel = uipanel('Visible','off', ...
                                       'BackgroundColor',[.8 .8 .8],...
                                       'BorderType', 'line',...
                                       'Position', panelCoords);
                                   
                                   
                % Title of view 1 options Panel  
                this.view1Tbox = uicontrol('Parent',this.view1optionsPanel, ...
                           'Style', 'text', 'String', viewTitle, ...
                           'HorizontalAlignment', 'left', 'FontSize', 11.5, ...
                           'Position', [42 313 170 27], 'BackgroundColor',[0.4863 0.72 0.8]);
                       
                % Title of view 1 Curent Cam (not the cam itself)  
                this.view1CurrentCamLabelTbox = uicontrol('Parent',this.view1optionsPanel, ...
                           'Style', 'text', 'String', ...
                           'Current Camera:', ...
                           'HorizontalAlignment', 'left', 'FontSize', 9, ...
                           'Position', [45 280 140 27], 'BackgroundColor',[.8 .8 .8]);
                       
                % Label of view 1 Curent Cam (actual cam itself)  
                this.view1CurrentCamLabelTbox = uicontrol('Parent',this.view1optionsPanel, ...
                           'Style', 'text', 'String', ...
                           'Camera 1', 'FontWeight', 'bold', ...
                           'HorizontalAlignment', 'left', 'FontSize', 9, ...
                           'Position', [150 280 100 27], 'BackgroundColor',[.8 .8 .8]);
                
                %THE NEXT THREE ARE FOR AESTHETICS ONLY. to give the panel a more tab-like feel       
                       
                this.snapshotBorder = uicontrol('Parent',this.view1optionsPanel, ...
                           'Style', 'text', 'String', ...
                           ' ', 'Visible', 'on',...
                           'HorizontalAlignment', 'left', 'FontSize', 8, ...
                           'Position', [1 258 85 29], 'BackgroundColor',[0 0 0]);
                       
                this.burstBorder = uicontrol('Parent',this.view1optionsPanel, ...
                           'Style', 'text', 'String', ...
                           ' ', 'Visible', 'off',...
                           'HorizontalAlignment', 'left', 'FontSize', 8, ...
                           'Position', [83 258 87 29], 'BackgroundColor',[0 0 0]);
                       
                this.videoBorder = uicontrol('Parent',this.view1optionsPanel, ...
                           'Style', 'text', 'String', ...
                           ' ', 'Visible', 'off',...
                           'HorizontalAlignment', 'left', 'FontSize', 8, ...
                           'Position', [168 258 87 29], 'BackgroundColor',[0 0 0]);
                       
                                     
                % The View 1 Snapshot button                                 
                 this.viewSnapshot = uicontrol('Parent', this.view1optionsPanel, 'Style', 'pushbutton',...
                           'String', 'Snapshot', 'Position', [3 260 81 25],...
                           'Callback', @this.snapshot_cb, 'BackgroundColor',[.95 .95 .95]);
                       
                % The View 1 Burst button                                 
                 this.viewBurst = uicontrol('Parent', this.view1optionsPanel, 'Style', 'pushbutton',...
                           'String', 'Burst', 'Position', [87 260 81 25],...
                           'Callback', @this.burst_cb, 'BackgroundColor',[0.4863 0.72 0.8]);
                       
                % The View 1 Video button                                 
                 this.viewVideo = uicontrol('Parent', this.view1optionsPanel, 'Style', 'pushbutton',...
                           'String', 'Video', 'Position', [171 260 81 25],...
                           'Callback', @this.video_cb, 'BackgroundColor',[0.4863 0.72 0.8]);
                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                %Snapshot panel
                this.snapshotPanel = uipanel('Visible','on', 'parent', this.view1optionsPanel,...
                                           'BackgroundColor',[.95 .95 .95], 'BorderType', 'line',...
                                           'HighlightColor',[0 0 0], 'BorderWidth', 2,...
                                           'Position', [0 .245 1 .51]);
                                       
                       %Save to Specific Folder checkbox (snapshot panel)
                       this.specificSaveCheckBoxSnapshot = uicontrol('Parent', this.snapshotPanel, 'Style',...
                                'checkbox', 'Position', [40 129 15 15], 'Value', 0,...
                                'BackgroundColor',[.95 .95 .95], 'Callback', @this.saveCheckboxSpecificSnapshot_cb);

                       %label of Save to specific folder (snapshot panel)  
                       this.specificSaveLabelTBoxSnapshot = uicontrol('Parent',this.snapshotPanel, ...
                                   'Style', 'text', 'String', ...
                                   '  Save to Specific Folder', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 7.5, ...
                                   'Position', [60 130 150 13], 'BackgroundColor',[.95 .95 .95]);

                       %Save to specific folder edit box                                
                       this.specificSaveEditBoxSnapshot = uicontrol('Parent', this.snapshotPanel, 'Style', 'edit',...
                                   'Position', [10 100 235 25]);
                                       
                        % capture frame button (snapshot panel)                             
                        this.captureFrameSnapshot = uicontrol('Parent', this.snapshotPanel, 'Style', 'pushbutton',...
                                   'String', 'Capture Frame', 'Position', [10 30 100 25],...
                                   'Callback', @this.captureFrame_cb, 'BackgroundColor',[0.4863 0.72 0.8]);
                               
                        %Title of Save options Panel (snapshot panel) 
                        this.saveOptionsTBoxSnapshot = uicontrol('Parent',this.snapshotPanel, ...
                                   'Style', 'text', 'String', ...
                                   'Save Options', ...
                                   'HorizontalAlignment', 'center', 'FontSize', 8, ...
                                   'Position', [134 64 100 13], 'BackgroundColor',[.95 .95 .95]);

                         %Save Options panel (snapshot panel).      
                         this.saveOptionsPanelSnapshot = uipanel('Parent',this.snapshotPanel, ...
                                               'BackgroundColor',[.95 .95 .95],...
                                               'BorderType', 'line',...
                                               'HighlightColor', [1 0 0],...
                                               'Position', [.48 .027 .49 .32]);

                                   %Preview option checkbox (snapshot panel)
                                   this.previewCheckBoxSnapshot = uicontrol('Parent', this.saveOptionsPanelSnapshot, 'Style',...
                                            'checkbox', 'Position', [5 32 15 15], 'Value', 0,...
                                            'BackgroundColor',[.95 .95 .95]);

                                   %label of preview checkbox (snapshot panel)  
                                   this.previewLabelTBoxSnapshot = uicontrol('Parent',this.saveOptionsPanelSnapshot, ...
                                               'Style', 'text', 'String', ...
                                               '  Preview', ...
                                               'HorizontalAlignment', 'left', 'FontSize', 7.5, ...
                                               'Position', [20 33 70 13], 'BackgroundColor',[.95 .95 .95]);

                                   %Save option checkbox (snapshot panel)
                                   this.saveCheckBoxSnapshot = uicontrol('Parent', this.saveOptionsPanelSnapshot, 'Style',...
                                            'checkbox', 'Position', [5 7 15 15], 'Value', 1, ...
                                            'BackgroundColor',[.95 .95 .95], 'Callback', @this.saveCheckboxGenericSnapshot_cb);

                                   %label of save checkbox (snapshot panel)  
                                   this.saveLabelTBoxSnapshot = uicontrol('Parent',this.saveOptionsPanelSnapshot, ...
                                               'Style', 'text', 'String', ...
                                               '  Save to disk', ...
                                               'HorizontalAlignment', 'left', 'FontSize', 7.5, ...
                                               'Position', [20 8 70 13], 'BackgroundColor',[.95 .95 .95]);
                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                %Burst panel
                this.burstPanel = uipanel('Visible','off', 'parent', this.view1optionsPanel,...
                                           'BackgroundColor',[.9 .9 .9], 'BorderType', 'line',...
                                           'HighlightColor',[0 0 0], 'BorderWidth', 2,...
                                           'Position', [0 .245 1 .51]);
                                       
                                       
                                       
                                       
                                       
                    % Title Capture Series Conditions  (burst panel)
                    this.captureSeriesConditionsTitleTboxBurst = uicontrol('Parent',this.burstPanel, ...
                               'Style', 'text', 'String', ...
                               'Capture Series Conditions:', ...
                               'HorizontalAlignment', 'left', 'FontSize', 8, ...
                               'Position', [13 150 150 16], 'BackgroundColor',[.9 .9 .9]);

                     %Capture Series Options panel. (burst panel)      
                     this.captureSeriesOptionsPanelBurst = uipanel('Parent',this.burstPanel, ...
                                           'BackgroundColor',[.9 .9 .9],...
                                           'BorderType', 'line',...
                                           'HighlightColor', [1 0 0],...
                                           'Position', [.06 .67 .91 .20]);

                                %Capture Series COnditions text (burst panel)
                                this.captureSeriesConditionsLabelTboxBurst = uicontrol('Parent',this.captureSeriesOptionsPanelBurst, ...
                                           'Style', 'text', 'String', ...
                                           'frames captured in            seconds', ...
                                           'HorizontalAlignment', 'center', 'FontSize', 8, ...
                                           'Position', [41 2 170 23], 'BackgroundColor',[.9 .9 .9]);

                                % The capture Series frame number edit box (burst)                                 
                                 this.captureSeriesFrameNumberEditBurst = uicontrol('Parent', this.captureSeriesOptionsPanelBurst, 'Style', 'edit',...
                                           'Position', [13 4 25 25]);

                                % The capture Series time number edit box   (burst)                              
                                 this.captureSeriesTimeNumberEditBurst = uicontrol('Parent', this.captureSeriesOptionsPanelBurst, 'Style', 'edit',...
                                           'Position', [140 4 25 25]);
                                       
  
                                       
                       %Save to Specific Folder checkbox (Burst panel)
                       this.specificSaveCheckBoxBurst = uicontrol('Parent', this.burstPanel, 'Style',...
                                'checkbox', 'Position', [40 94 15 15], 'Value', 0,...
                                'BackgroundColor',[.90 .90 .90], 'Callback', @this.saveCheckboxSpecificBurst_cb);

                       %label of Save to specific folder (Burst panel)  
                       this.specificSaveLabelTBoxBurst = uicontrol('Parent',this.burstPanel, ...
                                   'Style', 'text', 'String', ...
                                   '  Save to Specific Folder', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 7.5, ...
                                   'Position', [60 95 150 13], 'BackgroundColor',[.90 .90 .90]);

                       %Save to specific folder edit box (Burst panel)                               
                       this.specificSaveEditBoxBurst = uicontrol('Parent', this.burstPanel, 'Style', 'edit',...
                                   'Position', [10 65 235 25]);
                                       
                        % capture frame button (burst panel)                             
                        this.captureSeriesBurst = uicontrol('Parent', this.burstPanel, 'Style', 'pushbutton',...
                                   'String', 'Capture Series', 'Position', [10 15 100 25],...
                                   'Callback', @this.captureSeries_cb, 'BackgroundColor',[0.4863 0.72 0.8]);
                               
                        %Title of Save options Panel (burst panel) 
                        this.saveOptionsTBoxBurst = uicontrol('Parent',this.burstPanel, ...
                                   'Style', 'text', 'String', ...
                                   'Save Options:', ...
                                   'HorizontalAlignment', 'center', 'FontSize', 8, ...
                                   'Position', [10 45 100 13], 'BackgroundColor',[.90 .90 .90]);

                         %Save Options panel (burst panel).      
                         this.saveOptionsPanelBurst = uipanel('Parent',this.burstPanel, ...
                                               'BackgroundColor',[.90 .90 .90],...
                                               'BorderType', 'line',...
                                               'HighlightColor', [1 0 0],...
                                               'Position', [.48 .027 .49 .32]);

                                   %Preview option checkbox (burst panel)
                                   this.previewCheckBoxBurst = uicontrol('Parent', this.saveOptionsPanelBurst, 'Style',...
                                            'checkbox', 'Position', [5 32 15 15], 'Value', 0,...
                                            'BackgroundColor',[.90 .90 .90]);

                                   %label of preview checkbox (burst panel)  
                                   this.previewLabelTBoxBurst = uicontrol('Parent',this.saveOptionsPanelBurst, ...
                                               'Style', 'text', 'String', ...
                                               '  Preview', ...
                                               'HorizontalAlignment', 'left', 'FontSize', 7.5, ...
                                               'Position', [20 33 70 13], 'BackgroundColor',[.9 .9 .9]);

                                   %Save option checkbox (burst panel)
                                   this.saveCheckBoxBurst = uicontrol('Parent', this.saveOptionsPanelBurst, 'Style',...
                                            'checkbox', 'Position', [5 7 15 15], 'Value', 1, ...
                                            'BackgroundColor',[.9 .9 .9], 'Callback', @this.saveCheckboxGenericBurst_cb);

                                   %label of save checkbox (burst panel)  
                                   this.saveLabelTBoxBurst = uicontrol('Parent',this.saveOptionsPanelBurst, ...
                                               'Style', 'text', 'String', ...
                                               '  Save to disk', ...
                                               'HorizontalAlignment', 'left', 'FontSize', 7.5, ...
                                               'Position', [20 8 70 13], 'BackgroundColor',[.9 .9 .9]);
                                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                       
                %Video panel
                this.videoPanel = uipanel('Visible','off', 'parent', this.view1optionsPanel,...
                                           'BackgroundColor',[.85 .85 .85], 'BorderType', 'line',...
                                           'HighlightColor',[0 0 0], 'BorderWidth', 2,...
                                           'Position', [0 .245 1 .51]);
                                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                       
                %Message board panel
                this.messageBoardPanel = uipanel('Title', 'Message Board', 'parent', this.view1optionsPanel,...
                                           'BackgroundColor',[.95 .95 .95], 'BorderType', 'line',...
                                           'HighlightColor',[0 0 0], 'BorderWidth', 2,...
                                           'Position', [0 .01 1 .25]);
                                       
                        %Text of Message Board
                        this.messageBoardText = uicontrol('Parent',this.messageBoardPanel, ...
                                   'Style', 'text', 'String', ...
                                   ' ', ...
                                   'HorizontalAlignment', 'left', 'FontSize', 8, ...
                                   'Position', [1 1 250 71], 'BackgroundColor',[.95 .95 .95]);
                               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                       
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
            
            set(this.messageBoardPanel,'BackgroundColor',[.95 .95 .95]);
            set(this.messageBoardText,'BackgroundColor',[.95 .95 .95]);
            
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
            
            set(this.messageBoardPanel,'BackgroundColor',[.9 .9 .9]);
            set(this.messageBoardText,'BackgroundColor',[.9 .9 .9]);
            
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
            
            set(this.messageBoardPanel,'BackgroundColor',[.85 .85 .85]);
            set(this.messageBoardText,'BackgroundColor',[.85 .85 .85]);
            
            %This just erases the message board
            set(this.messageBoardText, 'String', ' ');
            
        end
        
        function captureFrame_cb(this,~,~)
            
            %This just erases the message board
            set(this.messageBoardText, 'String', ' ');
            
            notify(this, 'captureFrame');

        end
        
        function captureSeries_cb(this,~,~)
            
            %This just erases the message board
            set(this.messageBoardText, 'String', ' ');
            
            notify(this, 'captureSeries');

        end
        
        %The next two functions just make sure that the two save checkboxes
        %is the Snapshot panel coordinate with each other.
        function saveCheckboxSpecificSnapshot_cb(this,~,~)
            checkConditionSpecificSnapshot = get(this.specificSaveCheckBoxSnapshot,'Value');
            if checkConditionSpecificSnapshot == 1
               set(this.saveCheckBoxSnapshot,'Value', 1); 
            else
               set(this.saveCheckBoxSnapshot,'Value', 0);
            end
        end
        function saveCheckboxGenericSnapshot_cb(this,~,~)
            checkConditionGenericSnapshot = get(this.saveCheckBoxSnapshot,'Value');
            if checkConditionGenericSnapshot == 0
               set(this.specificSaveCheckBoxSnapshot,'Value', 0); 
            end
        end
        
        %The next two functions just make sure that the two save checkboxes
        %is the Burst panel coordinate with each other.
        function saveCheckboxSpecificBurst_cb(this,~,~)
            checkConditionSpecificBurst = get(this.specificSaveCheckBoxBurst,'Value');
            if checkConditionSpecificBurst == 1
               set(this.saveCheckBoxBurst,'Value', 1); 
            else
               set(this.saveCheckBoxBurst,'Value', 0);
            end
        end
        function saveCheckboxGenericBurst_cb(this,~,~)
            checkConditionGenericBurst = get(this.saveCheckBoxBurst,'Value');
            if checkConditionGenericBurst == 0
               set(this.specificSaveCheckBoxBurst,'Value', 0); 
            end
        end
        
        
    end
end
