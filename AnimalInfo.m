     currentDir=pwd;
     [upperPath, deepestFolder]=fileparts(currentDir);
     R.animalID=deepestFolder;

ImportCSC_mac

%Import pos info from nlx
[VT1_TimeStamps,x,y,VT1_Targets,VT1_Header] = Nlx2MatVT('VT1.nvt',[1 1 1 0 1 0],1,1);

t=VT1_TimeStamps';
qq=t(1);
for uu=1:length(t)
    t(uu)=t(uu)-qq;
end
treshold=.5;
x1=x';y1=y';
x1(x1==0)=NaN;
y1(y1==0)=NaN;y1(y1<80)=NaN;x1(y1<80)=NaN;


% y1(isnan(y1)) = interp1(find(~isnan(y1)), y1(~isnan(y1)), find(isnan(y1)));
% x1(isnan(x1)) = interp1(find(~isnan(x1)), x1(~isnan(x1)), find(isnan(x1)));

R.Pos.t=t/1e+06;


     scale_x=range(x1)/65;
     x1=x1/scale_x;
     
     scale_y=range(y1)/41;
     y1=y1/scale_y;
    centre = centreBox(x1,y1);
    


    R.Pos.x1 = x1 - centre(1);
    R.Pos.y1 = y1 - centre(2);
    
%     if string(pwd)==('C:\Users\macayla\Desktop\Macayla_CA2\WT_3chambers\Amigo3_3chamber')
%     badPosInd=find(R.Pos.y1<-10);
%     R.Pos.x1(badPosInd)=NaN;
%     R.Pos.y1(badPosInd)=NaN;
%     R.Pos.x1=naninterp(R.Pos.x1);
%     R.Pos.y1=naninterp(R.Pos.y1);
%     else
%     end
    
    create_timeStamps;
%     ImportEvents
% z=2;
% behavior.habituation=(Events_TimeStamps(z+1)-Events_TimeStamps(1)) - (Events_TimeStamps(z)-Events_TimeStamps(1));
% behavior.cup=(Events_TimeStamps(z+3)-Events_TimeStamps(1)) - (Events_TimeStamps(z+2)-Events_TimeStamps(1));
% behavior.fam1=(Events_TimeStamps(5+z)-Events_TimeStamps(1)) - (Events_TimeStamps(z+4)-Events_TimeStamps(1));
% behavior.novel1=(Events_TimeStamps(7+z)-Events_TimeStamps(1)) - (Events_TimeStamps(z+6)-Events_TimeStamps(1));
% behavior.fam2=(Events_TimeStamps(z+9)-Events_TimeStamps(1)) - (Events_TimeStamps(z+8)-Events_TimeStamps(1));
% %behavior.novel2=(Events_TimeStamps(14+z)-Events_TimeStamps(1)) - (Events_TimeStamps(13+z)-Events_TimeStamps(1));
% 
% % behavior.habituation=(Events_TimeStamps(z+1)-Events_TimeStamps(1)) - (Events_TimeStamps(z)-Events_TimeStamps(1));
% behavior.cup=(Events_TimeStamps(z+3)-Events_TimeStamps(1)) - (Events_TimeStamps(z+2)-Events_TimeStamps(1));
% behavior.fam1=(Events_TimeStamps(7+z)-Events_TimeStamps(1)) - (Events_TimeStamps(z+6)-Events_TimeStamps(1));
% behavior.novel=(Events_TimeStamps(10+z)-Events_TimeStamps(1)) - (Events_TimeStamps(z+9)-Events_TimeStamps(1));
% behavior.fam2=(Events_TimeStamps(14+z)-Events_TimeStamps(1)) - (Events_TimeStamps(z+11)-Events_TimeStamps(1));
    
%     %ONLY FOR DF4
%     if string(pwd)==('C:\Users\macayla\Desktop\Macayla_CA2\DF_3chambers\DF4_3chamber')
%         disp('no timestamp for hab_start')
%         Events_EventIDs=Events_EventIDs'; Eventlabels=Events_EventStrings(1:10,1);Eventlabels=Eventlabels';
%     else
%          
%     Events_EventIDs=Events_EventIDs'; Eventlabels=Events_EventStrings(Events_EventIDs==4);Eventlabels=Eventlabels';
%     
%     end
    R.TimeStamps=timeStamps;
    
    
    clearvars -except R p numCells smoothingChoice behavior