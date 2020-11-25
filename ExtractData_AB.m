function [R]=ExtractData_AB(smoothingChoice,numCells)
% Program parameters_______________________________________________________

% Bin width for the ratemap
p.sChoice = smoothingChoice;
p.binWidth = 1;
p.smoothing = 2;
p.smoothValues = [1.5, 3.0, 5.0, 7.5, 10, 15, 20, 30];
p.minNumBins = 9;
p.fieldTreshold = 0.4;
p.lowestFieldRate = 1;
p.trajmap = 1;
p.plotratemap = 1; 
p.gridscore = 1;
p.lowSpeedThreshold = 3; 
p.highSpeedThreshold = 0; % [cm/s]
p.imageDir = 'CorrelationImages\';
R.p=p;

% ** Image format for the images **
% format = 1 -> bmp (24 bit)
% format = 2 -> png
% format = 3 -> eps Vector graphics
% format = 4 -> jpg
% format = 5 -> ai Vector graphics (Adobe Illustrator)
% format = 6 -> tiff (24 bit)

% Image format for path images
p.pathImageFormat = 3;

% Image format for the rate maps images
p.mapImageFormat = 2;

% DPI setting for the image file
p.dpi = 300;

%Import CSCs
AnimalInfoAB

x1=R.Pos.x1;
y1=R.Pos.y1;
post=R.Pos.t;
plot(x1,y1)

goodPos=input('is the tracking bad? 1 for yes, 0 for no');


if goodPos==1
ymin=input('what is ymin?');ymax=input('what is ymax');
xmin=input('what is xmin?');xmax=input('what is xmax?');
xMAX=R.Pos.x1>xmax;
    R.Pos.x1(xMAX==1)=NaN;
xMIN=R.Pos.x1<xmin;
    R.Pos.x1(xMIN==1)=NaN;
yMAX=R.Pos.y1>ymax;
    R.Pos.y1(yMAX==1)=NaN;
yMIN=R.Pos.y1<ymin;
    R.Pos.y1(yMIN==1)=NaN;
end



speed = speed2D(R.Pos.x1,R.Pos.y1,R.Pos.t);
if range(speed)>25
    g=find(speed>25);
    R.Pos.x1(g)=NaN;
    R.Pos.y1(g)=NaN;
end

R.Pos.x1=naninterp(R.Pos.x1);
R.Pos.y1=naninterp(R.Pos.y1);
x1=R.Pos.x1;
y1=R.Pos.y1;
%center the positions
centre = centreBox(x1,y1);
x1c = x1 - centre(1);
y1c= y1 - centre(2);
         

    obsLength = max(max(x1c)-min(x1c),max(y1c)-min(y1c));
    bins = ceil(obsLength/p.binWidth);
    sLength = p.binWidth*bins;
    R.mapAxis = (-sLength/2+p.binWidth/2):p.binWidth:(sLength/2-p.binWidth/2);
    
    % Calulate what areas of the box that have been visited
    R.visited = visitedBins(x1c,y1c,R.mapAxis);
    R.Pos.x1=x1c; R.Pos.y1=y1c;
    

%[vel, vel_timestamps, path]=velocity(x1,y1,t);
%R.vel=smooth(vel);

    tetrodeID=dir('*.cut');
    for i=1:length(tetrodeID)
        tetrode=tetrodeID(i).name;
        cut{i}=getcut(tetrode);
        datafile = strcat('tint.',tetrode(6));
        Ts = getspikes(datafile); 
        
            for j=1:numCells
            unitmat=(find(cut{i}==j));
            unit_ts=Ts(unitmat);
            ext='.unit';
            Tetrode=num2str(tetrode(6));
            Tetrode=strcat('TT',Tetrode);
            unit=num2str(j);
            unit=strcat('unit',j);
            R.cellID{j}=strcat(Tetrode,unit);
            
            [spkx,spky,ts] = spikePos(unit_ts,x1c,y1c,post,post);
            R.Spike.x{j,i}=spkx;
            R.Spike.y{j,i}=spky;
            R.Spike.t{j,i}=ts;
            
            end
    end


