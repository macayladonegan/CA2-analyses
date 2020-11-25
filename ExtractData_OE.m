function [R]=ExtractData_OE(smoothingChoice)
% Program parameters_______________________________________________________

% Bin width for the ratemap
p.sChoice = 1;
p.binWidth = 2;
p.smoothing = 2;
p.smoothValues = [1.5, 3.0, 5.0, 7.5, 10, 15, 20, 30];
p.minNumBins = 9;
p.maxNumBins = 250;
p.fieldTreshold = 0.4;
p.lowestFieldRate = 1;
p.trajmap = 1;
p.plotratemap = 1; 
p.gridscore = 1;
p.lowSpeedThreshold = 3; 
p.highSpeedThreshold = 0; % [cm/s]
p.imageDir = 'CorrelationImages\';
R.p=p;

trajFile=ls('*trajectories.mat*');
load(trajFile)

x=trajectories(:,:,1);
y=trajectories(:,:,2);
%load('LFPtimestamps.mat')
rec_length=LFPtimestamps(end)-LFPtimestamps(1);
t=(rec_length/length(x):rec_length/length(x):rec_length)'; %%this needs to line up with the length of the recording


scale_x=range(x)/65;
x=x/scale_x;

scale_y=range(y)/41;
y=y/scale_y;
centre = centreBox(x,y);
x = x - centre(1);
y = y - centre(2);
    

speed = speed2D(x,y,t);
if range(speed)>20
    g=find(speed>20);
    x(g)=NaN;
    y(g)=NaN;
end

plot(x,y)
goodPos=input('is the tracking bad? 1 for yes, 0 for no');

if goodPos==1
ymin=input('what is ymin?');ymax=input('what is ymax');
xmin=input('what is xmin?');xmax=input('what is xmax?');
xMAX=x>xmax;
    x(xMAX==1)=NaN;
xMIN=x<xmin;
    x(xMIN==1)=NaN;
yMAX=y>ymax;
    y(yMAX==1)=NaN;
yMIN=y<ymin;
   y(yMIN==1)=NaN;
end


x=naninterp(x,'linear');
y=naninterp(y,'linear');

%t=0::length(x)/10;%%how to get timestamps?


    obsLength = max(max(x)-min(x),max(y)-min(y));
    bins = ceil(obsLength/R.p.binWidth);
    sLength = R.p.binWidth*bins;
    R.mapAxis = (-sLength/2+R.p.binWidth/2):R.p.binWidth:(sLength/2-R.p.binWidth/2);
    
    % Calulate what areas of the box that have been visited
    R.visited = visitedBins(x,y,R.mapAxis);
    R.Pos.x1=x; R.Pos.y1=y;R.Pos.t=t;
    
    load('Events.mat');
    R.Timestamps=Events.timestamps(1:2:end)-Events.timestamps(1);
%%load Spikes
TTs=ls('Binaries*'); sizeTTs=size(TTs);

for jj=1:sizeTTs(1)
    thisTT=TTs(jj,1:end);
    cd(thisTT)
    
    spikeStruct = loadKSdir(pwd);
    numClust=length(spikeStruct.cids);
    
    for ii=1:numClust
        if spikeStruct.cgs(1,ii)==2
            thisClust=spikeStruct.cids(ii);
            spikeInds=find(spikeStruct.clu==thisClust);
            spikeTimes{ii,jj}=spikeStruct.st(spikeInds);
            if ~isempty(spikeTimes)
            [spkx,spky,ts]=spikePos(spikeTimes{ii,jj},R.Pos.x1,R.Pos.y1,R.Pos.t,R.Pos.t);
            R.Spike.t{jj,ii}=ts;
            R.Spike.x{jj,ii}=spkx;
            R.Spike.y{jj,ii}=spky;
            end
        end
    end
    clear spikeStruct
    cd ..
    
end

  
