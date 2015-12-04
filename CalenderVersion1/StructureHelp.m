load('ScheduleDataFile2.mat')



event2 = struct('dateIDstart','20150701',...
                'startTime','18:00:00',...
                'dateIDend','20150701',...
                'endTime','19:00:00',...
                'dateStartMatrix',[2015,07,01],...
                'cameraID','Camera1',...
                'action','still',...
                'repeatID','none');
            
save('ScheduleDataFile2.mat','event2')
                

event2(end+1).dateIDstart = '20150707';
event2(end).startTime = '00:00:00';
event2(end).dateIDend = '20150707';
event2(end).endTime = '01:00:00';
event2(end).dateStartMatrix = [2015,07,07];
event2(end).cameraID = 'Camera2';
event2(end).action = 'still';
event2(end).repeatID = 'none';

event2(end+1).dateIDstart = '20150707';
event2(end).startTime = '01:00:00';
event2(end).dateIDend = '20150707';
event2(end).endTime = '02:00:00';
event2(end).dateStartMatrix = [2015,07,07];
event2(end).cameraID = 'Camera3';
event2(end).action = 'still';
event2(end).repeatID = 'none';

event2(end+1).dateIDstart = '20150707';
event2(end).startTime = '03:00:00';
event2(end).dateIDend = '20150707';
event2(end).endTime = '04:00:00';
event2(end).dateStartMatrix = [2015,07,07];
event2(end).cameraID = 'Camera4';
event2(end).action = 'still';
event2(end).repeatID = 'none';


event2(1)=[] %deletes first entry of structure

aaa = StructureOrdering2;
rangeSort = aaa.filterForSpecificRange(event2, '20150701', '00:00:00', '20150701', '23:59:59');

aaa = StructureOrdering2;
camSort = aaa.filterForSpecificCamera(event2, 'Camera 1');