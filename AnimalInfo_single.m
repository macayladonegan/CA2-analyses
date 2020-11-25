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
y1(y1==0)=NaN;

x1(isnan(x1)) = interp1(find(~isnan(x1)),x1(~isnan(x1)), find(isnan(x1)),'linear');
y1(isnan(y1)) = interp1(find(~isnan(y1)), y1(~isnan(y1)), find(isnan(y1)),'linear');


R.Pos.t=t/1e+06;

    centre = centreBox(x1,y1);
    


    R.Pos.x1 = x1 - centre(1);
    R.Pos.y1 = y1 - centre(2);
    
    
    clearvars -except R p numCells smoothingChoice 