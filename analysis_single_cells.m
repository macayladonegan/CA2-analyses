%% Analysis core

% Bin width for the ratemap
p.sChoice = 0.15;
p.binWidth = 1.5;
p.smoothing = 1.5;
p.smoothValues = [1.5, 3.0, 5.0, 7.5, 10, 15, 20, 30];
p.minNumBins = 9;
p.fieldTreshold = 0.2;
p.lowestFieldRate = 1;
p.trajmap = 1;
p.plotratemap = 1; 
p.gridscore = 1;
p.lowSpeedThreshold = 3; 
p.highSpeedThreshold = 0; % [cm/s]
p.imageDir = 'CorrelationImages\';
R.p=p;


% Image format for path images
p.pathImageFormat = 3;

% Image format for the rate maps images
p.mapImageFormat = 2;

% DPI setting for the image file
p.dpi = 300;

%Import CSCs
AnimalInfo


x1=R.Pos.x1;
y1=R.Pos.y1;
post=R.Pos.t;

    obsLength = max(max(x1)-min(x1),max(y1)-min(y1));
    bins = ceil(obsLength/p.binWidth);
    sLength = p.binWidth*bins;
    R.mapAxis = (-sLength/2+p.binWidth/2):p.binWidth:(sLength/2-p.binWidth/2);
    
    % Calulate what areas of the box that have been visited
    R.visited = visitedBins(x1,y1,R.mapAxis);

    %[vel, vel_timestamps, path]=velocity(x1,y1,t);
    %R.vel=smooth(vel);

    tetrodeID=dir('*.cut');
    for i=1:length(tetrodeID)
        tetrode=tetrodeID(i).name;
        cut{i}=getcut(tetrode);
        datafile = strcat('tint.',tetrode(6));
        Ts = getspikes(datafile); 
        
        numCells=length(unique(cut{i}));      
            for j=1:numCells
                unitmat=(find(cut{i}==j));
                unit_ts=Ts(unitmat);
                ext='.unit';
                Tetrode=num2str(tetrode(6));
                Tetrode=strcat('TT',Tetrode);
                unit=num2str(j);
                unit=strcat('unit',num2str(j));
                R.cellID{j}=strcat(Tetrode,unit);

                [spkx,spky,ts] = spikePos(unit_ts,x1,y1,post,post);
                R.Spike.x{j,i}=spkx;
                R.Spike.y{j,i}=spky;
                R.Spike.t{j,i}=ts;
            end
    end

%% get individual firing rates for individual cells analysis
ntotal=0;

for i=1:size(R.Spike.t,1)
    for j=1:size(R.Spike.t,2)
    if ~isempty(R.Spike.t{i,j})
        ntotal=ntotal+1;
    end
    end
end
clear i

count=0;
for i=1:size(R.Spike.t,1)
    for j=1:size(R.Spike.t,2)
    if ~isempty(R.Spike.t{i,j})
        count=count+1;
        FR(count,1) = length(find(R.Spike.t{i,j}<behavior.habituation))/(behavior.habituation);
        FR(count,2) = length(find(R.Spike.t{i,j}>=behavior.habituation & R.Spike.t{i,j}<=(behavior.habituation+behavior.cup)))/(behavior.cup);
        FR(count,3) = length(find(R.Spike.t{i,j}>=(behavior.habituation+behavior.cup) & R.Spike.t{i,j}<=(behavior.habituation+behavior.cup+behavior.fam1)))/(behavior.fam1);
        FR(count,4) = length(find(R.Spike.t{i,j}>=(behavior.habituation+behavior.cup+behavior.fam1) & R.Spike.t{i,j}<=(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel)))/(behavior.novel);
        FR(count,5) = length(find(R.Spike.t{i,j}>=(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel) & R.Spike.t{i,j}<=(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel+behavior.fam2)))/(behavior.fam2);        
    end
    end
end
clear i

%zscore FR to get rid of the higher firing rate cells influence
for i=1:ntotal
    FRz(i,:) = zscore(FR(i,:));
end
clear i
%%

%Figure1 a) left
figure
barwitherr([std(FR(:,1))/sqrt(size(FR,1));std(FR(:,2))/sqrt(size(FR,1));std(FR(:,3))/sqrt(size(FR,1));...
    std(FR(:,4))/sqrt(size(FR,1));std(FR(:,5))/sqrt(size(FR,1))],...
    [mean(FR(:,1));mean(FR(:,2));mean(FR(:,3));mean(FR(:,4));mean(FR(:,5))]);


%Figure1 a) rigth
figure
for i =1:ntotal
    hold on;
    plot(FR(i,:),'-mo','color',rand(1,3));
end
clear i

%Figure1 b) left
figure
bar([mean((FRz(:,1)));mean((FRz(:,2)));mean((FRz(:,3)));mean((FRz(:,4)));mean((FRz(:,5)))]);


%Figure1 b) right
%find preferred stage for cells firing
for i=1:ntotal
    preferred_stage(i) = find(FR(i,:)==max(FR(i,:)));
end
clear i
%count proportion
for i =1:5
    preferred(i) = length(find(preferred_stage==i))/size(preferred_stage,2);
end
clear i

figure
bar(preferred);


%Figure1 c) left = box plots
figure
boxplot(FRz(:,2));ylim([-2 2]);
figure
boxplot(FRz(:,1));ylim([-2 2]);
figure
boxplot(FRz(:,4));ylim([-3 5]);
figure
boxplot(mean([FRz(:,3),FRz(:,3)],2));ylim([-3 5]);
figure
boxplot([-0.2368,0.2954,0.2458,-0.9874,-0.3515,1.3969,-0.7086,1.3100,1.3911,-0.0624,0.1281,-0.4843,-1.0588,-0.2860,-0.6562,-0.9615]);ylim([-3 5]);
%Figure1 c) right = ratio plots


%%

%Figure 3
order = [];
temp = find(preferred_stage==4); %cause I see this as a main group
order = cat(2,order,temp);clear temp
temp = find(preferred_stage==2); %cause I see this as a main group also
order = cat(2,order,temp);clear temp
temp = find(preferred_stage==3); %cause I see this as a main group
order = cat(2,order,temp);clear temp
temp = find(preferred_stage==1); %cause I see this as a main group
order = cat(2,order,temp);clear temp
temp = find(preferred_stage==5); %cause I see this as a main group
order = cat(2,order,temp);clear temp


figure
for i =1:ntotal
    subplot(ntotal,1,i);
    bar(FRz(order(i),:));
    ylim([-2 2]);
    set(gca,'visible','off');
end
clear i

%FR reorder following preferred stage of firing
for i =1:ntotal
    FRz_reorder(i,:)=FRz(order(i),:);
    FR_reorder(i,:)=FR(order(i),:);
end
clear i

figure
imagesc(FRz_reorder);
%With FR without normalizing you dont see anything!
% figure
% imagesc(FR_reorder);


%%
%Figure 4
figure
plot(FRz(:,1),FRz(:,2),'.r','MarkerSize',20);hold on;xlim([-1.5 2]);ylim([-1.5 2]);
figure
plot(mean([FRz(:,3),FRz(:,5)],2),FRz(:,4),'.r','MarkerSize',20);hold on;xlim([-1.5 2]);ylim([-1.5 2]);
figure
plot(FRz(:,2),FRz(:,4),'.r','MarkerSize',20);hold on;xlim([-1.5 2]);ylim([-1.5 2]);
figure
plot(FRz(:,2),mean([FRz(:,3),FRz(:,5)],2),'.r','MarkerSize',20);hold on;xlim([-1.5 2]);ylim([-1.5 2]);
figure
plot(FRz(:,2),mean([FRz(:,3),FRz(:,5)],2),'.r','MarkerSize',20);hold on;xlim([-1.5 2]);ylim([-1.5 2]);

%% principal components? not really good for this data..

% [pc,score,latent,tsquare] = princomp(FRz);
% cumsum(latent)./sum(latent);
% figure
% biplot(pc(:,1:2),'Scores',score(:,1:2),'VarLabels',...
% 		{'X1' 'X2' 'X3' 'X4'})
% figure
% biplot(pc(:,1:2),'Scores',score(:,1:2))

%% place properties
neuron_n=0;

%manual normalization
for i =1:size(R.Spike.x,1)
    for j =1:size(R.Spike.x,2)
        if ~isempty(R.Spike.x{i,j})
            neuron_n = neuron_n+1;
            xx = R.Spike.x{i,j}./(max(R.Spike.x{i,j})-min(R.Spike.x{i,j}));
            pos_x{neuron_n,1} = xx+abs(min(xx)); clear xx
            yy = R.Spike.y{i,j}./(max(R.Spike.y{i,j})-min(R.Spike.y{i,j}));
            pos_y{neuron_n,1} = yy+abs(min(yy)); clear yy
            pos_t{neuron_n,1} = R.Spike.t{i,j};
            figure;plot(R.Spike.x{i,j},R.Spike.y{i,j},'.');
        end
    end
end
clear i j


%manual normalization
x2 = x./(max(x)-min(x(x>0)>0));x2(x2==0) = NaN;
y2 = y./(max(y)-min(y(y>0)>0));y2(y2==0) = NaN;


for i =1:1:neuron_n
    position = cat(2,t./1e6,x2',y2');
    spikes_habituation = pos_t{i}(pos_t{i}<behavior.habituation);
    spikes_cup = pos_t{i}(pos_t{i}<=(behavior.habituation+behavior.cup) & pos_t{i}>(behavior.habituation));
    spikes_fam1 = pos_t{i}(pos_t{i}<=(behavior.habituation+behavior.cup+behavior.fam1) & pos_t{i}>(behavior.habituation+behavior.cup));
    spikes_novel = pos_t{i}(pos_t{i}<=(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel) & pos_t{i}>(behavior.habituation+behavior.cup+behavior.fam1));
    spikes_fam2 = pos_t{i}(pos_t{i}<=(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel+behavior.fam2) & pos_t{i}>(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel));
    
    [map_habituation{i},stats_habituation{i}] = FiringMap(position,spikes_habituation,'nBins',100,'threshold',0.2,'minSize',7,'minPeak',2,'smooth',5);
    [map_cup{i},stats_cup{i}] = FiringMap(position,spikes_cup,'nBins',100,'threshold',0.2,'minSize',7,'minPeak',2,'smooth',5);
    [map_fam1{i},stats_fam1{i}] = FiringMap(position,spikes_fam1,'nBins',100,'threshold',0.2,'minSize',7,'minPeak',2,'smooth',5);
    [map_novel{i},stats_novel{i}] = FiringMap(position,spikes_novel,'nBins',100,'threshold',0.2,'minSize',7,'minPeak',2,'smooth',5);
    [map_fam2{i},stats_fam2{i}] = FiringMap(position,spikes_fam2,'nBins',100,'threshold',0.2,'minSize',7,'minPeak',2,'smooth',5);
    
    figure;subplot(2,5,1);PlotColorMap(map_habituation{i}.rate,map_habituation{i}.time);
    subplot(2,5,2);PlotColorMap(map_cup{i}.rate,map_cup{i}.time);
    subplot(2,5,3);PlotColorMap(map_fam1{i}.rate,map_fam1{i}.time);
    subplot(2,5,4);PlotColorMap(map_novel{i}.rate,map_novel{i}.time);
    subplot(2,5,5);PlotColorMap(map_fam2{i}.rate,map_fam2{i}.time);
    subplot(2,5,6);plot(pos_x{i}(pos_t{i}<=behavior.habituation),pos_y{i}(pos_t{i}<behavior.habituation),'.');
    subplot(2,5,7);plot(pos_x{i}(pos_t{i}<=(behavior.habituation+behavior.cup)&pos_t{i}>(behavior.habituation)),pos_y{i}((pos_t{i}<behavior.habituation+behavior.cup)&pos_t{i}>(behavior.habituation)),'.');
    subplot(2,5,8);plot(pos_x{i}(pos_t{i}<=(behavior.habituation+behavior.cup+behavior.fam1)&pos_t{i}>(behavior.habituation+behavior.cup)),pos_y{i}((pos_t{i}<behavior.habituation+behavior.cup+behavior.fam1)&pos_t{i}>(behavior.habituation+behavior.cup)),'.');
    subplot(2,5,9);plot(pos_x{i}(pos_t{i}<=(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel)&pos_t{i}>(behavior.habituation+behavior.cup+behavior.fam1)),pos_y{i}((pos_t{i}<behavior.habituation+behavior.cup+behavior.fam1+behavior.novel)&pos_t{i}>(behavior.habituation+behavior.cup+behavior.fam1)),'.');
    subplot(2,5,10);plot(pos_x{i}(pos_t{i}<=(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel+behavior.fam2)&pos_t{i}>(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel)),pos_y{i}((pos_t{i}<behavior.habituation+behavior.cup+behavior.fam1+behavior.novel+behavior.fam2)&pos_t{i}>(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel)),'.');
    
    [sInformation_1L,sInformation_2L,sSparsityL,sCoefficientL,sSelectivityL] = PlaceCellInfo(map_habituation{i}.rate, map_habituation{i}.count, map_habituation{i}.time);
    info{i}.habituation = [sInformation_1L,sInformation_2L,sSparsityL,sCoefficientL,sSelectivityL];
    clear sInformation_1L sInformation_2L sSparsityL sCoefficientL sSelectivityL
    
    [sInformation_1L,sInformation_2L,sSparsityL,sCoefficientL,sSelectivityL] = PlaceCellInfo(map_cup{i}.rate, map_cup{i}.count, map_cup{i}.time);
    info{i}.cup = [sInformation_1L,sInformation_2L,sSparsityL,sCoefficientL,sSelectivityL];
    clear sInformation_1L sInformation_2L sSparsityL sCoefficientL sSelectivityL
    
    [sInformation_1L,sInformation_2L,sSparsityL,sCoefficientL,sSelectivityL] = PlaceCellInfo(map_fam1{i}.rate, map_fam1{i}.count, map_fam1{i}.time);
    info{i}.map_fam1 = [sInformation_1L,sInformation_2L,sSparsityL,sCoefficientL,sSelectivityL];
    clear sInformation_1L sInformation_2L sSparsityL sCoefficientL sSelectivityL
    
    [sInformation_1L,sInformation_2L,sSparsityL,sCoefficientL,sSelectivityL] = PlaceCellInfo(map_fam2{i}.rate, map_fam2{i}.count, map_fam2{i}.time);
    info{i}.map_fam2 = [sInformation_1L,sInformation_2L,sSparsityL,sCoefficientL,sSelectivityL];
    clear sInformation_1L sInformation_2L sSparsityL sCoefficientL sSelectivityL
    
    
    [sInformation_1L,sInformation_2L,sSparsityL,sCoefficientL,sSelectivityL] = PlaceCellInfo(map_novel{i}.rate, map_novel{i}.count, map_novel{i}.time);
    info{i}.map_novel = [sInformation_1L,sInformation_2L,sSparsityL,sCoefficientL,sSelectivityL];
    clear sInformation_1L sInformation_2L sSparsityL sCoefficientL sSelectivityL
    
    
%     figure;
%     subplot(1,2,2);plot(pos_x{i},pos_y{i},'.');
    clear spikes_habituation spikes_cup spikes_fam1 spikes_novel spikes_fam2
    clear position
end
clear i

%% check what is different betweeen cells of familiar mouse and familiar mouse position different

figure
plot(FRz(:,3),FRz(:,5),'.r','MarkerSize',20);hold on;xlim([-1.5 2]);ylim([-1.5 2]);


%check if I can predict Place Cells whit the two sessions of fam mouse
who = [];
for i =1:length(FRz)
    if FRz(i,5) > FRz(i,3)
        who = cat(1,who,i);
    end
end
clear i

specificity_2 =[];info1_2=[];info2_2=[];spars_2=[];
specificity_1 =[];info1_1=[];info2_1=[];spars_1=[];
for i =1:1:ntotal
    
    if ~isempty(find(i==who))
    position = cat(2,t./1e6,x2',y2');
    spikes_habituation = pos_t{i}(pos_t{i}<behavior.habituation);
    spikes_cup = pos_t{i}(pos_t{i}<=(behavior.habituation+behavior.cup) & pos_t{i}>(behavior.habituation));
    spikes_fam1 = pos_t{i}(pos_t{i}<=(behavior.habituation+behavior.cup+behavior.fam1) & pos_t{i}>(behavior.habituation+behavior.cup));
    spikes_novel = pos_t{i}(pos_t{i}<=(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel) & pos_t{i}>(behavior.habituation+behavior.cup+behavior.fam1));
    spikes_fam2 = pos_t{i}(pos_t{i}<=(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel+behavior.fam2) & pos_t{i}>(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel));
    
    [map_habituation{i},stats_habituation{i}] = FiringMap(position,spikes_habituation,'nBins',100,'threshold',0.2,'minSize',7,'minPeak',2,'smooth',5);
    [map_cup{i},stats_cup{i}] = FiringMap(position,spikes_cup,'nBins',100,'threshold',0.2,'minSize',7,'minPeak',2,'smooth',5);
    [map_fam1{i},stats_fam1{i}] = FiringMap(position,spikes_fam1,'nBins',100,'threshold',0.2,'minSize',7,'minPeak',2,'smooth',5);
    [map_novel{i},stats_novel{i}] = FiringMap(position,spikes_novel,'nBins',100,'threshold',0.2,'minSize',7,'minPeak',2,'smooth',5);
    [map_fam2{i},stats_fam2{i}] = FiringMap(position,spikes_fam2,'nBins',100,'threshold',0.2,'minSize',7,'minPeak',2,'smooth',5);
    specificity_2 = cat(1,specificity_2,stats_fam2{i}.specificity);
    info1_2 = cat(1,info1_2,info{i}.map_fam1(1)); info2_2 = cat(1,info2_2,info{i}.map_fam2(2)); spars_2 = cat(1,spars_2,info{i}.map_fam1(3));

    figure;subplot(2,5,1);PlotColorMap(map_habituation{i}.rate,map_habituation{i}.time);
    subplot(2,5,2);PlotColorMap(map_cup{i}.rate,map_cup{i}.time);
    subplot(2,5,3);PlotColorMap(map_fam1{i}.rate,map_fam1{i}.time);
    subplot(2,5,4);PlotColorMap(map_novel{i}.rate,map_novel{i}.time);
    subplot(2,5,5);PlotColorMap(map_fam2{i}.rate,map_fam2{i}.time);
    subplot(2,5,6);plot(pos_x{i}(pos_t{i}<=behavior.habituation),pos_y{i}(pos_t{i}<behavior.habituation),'.');
    subplot(2,5,7);plot(pos_x{i}(pos_t{i}<=(behavior.habituation+behavior.cup)&pos_t{i}>(behavior.habituation)),pos_y{i}((pos_t{i}<behavior.habituation+behavior.cup)&pos_t{i}>(behavior.habituation)),'.');
    subplot(2,5,8);plot(pos_x{i}(pos_t{i}<=(behavior.habituation+behavior.cup+behavior.fam1)&pos_t{i}>(behavior.habituation+behavior.cup)),pos_y{i}((pos_t{i}<behavior.habituation+behavior.cup+behavior.fam1)&pos_t{i}>(behavior.habituation+behavior.cup)),'.');
    subplot(2,5,9);plot(pos_x{i}(pos_t{i}<=(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel)&pos_t{i}>(behavior.habituation+behavior.cup+behavior.fam1)),pos_y{i}((pos_t{i}<behavior.habituation+behavior.cup+behavior.fam1+behavior.novel)&pos_t{i}>(behavior.habituation+behavior.cup+behavior.fam1)),'.');
    subplot(2,5,10);plot(pos_x{i}(pos_t{i}<=(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel+behavior.fam2)&pos_t{i}>(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel)),pos_y{i}((pos_t{i}<behavior.habituation+behavior.cup+behavior.fam1+behavior.novel+behavior.fam2)&pos_t{i}>(behavior.habituation+behavior.cup+behavior.fam1+behavior.novel)),'.');
    suptitle(['Cell n= ' num2str(i)]);
%     figure;
%     subplot(1,2,2);plot(pos_x{i},pos_y{i},'.');
    clear spikes_habituation spikes_cup spikes_fam1 spikes_novel spikes_fam2
    clear position
    else
    specificity_1 = cat(1,specificity_1,stats_fam1{i}.specificity);
    info1_1 = cat(1,info1_1,info{i}.map_fam1(1)); info2_1 = cat(1,info2_1,info{i}.map_fam2(2)); spars_1 = cat(1,spars_1,info{i}.map_fam1(3));

    end
end
clear i

figure
subplot(2,2,1);bar([nanmean(specificity_2),nanmean(specificity_1)]);title('specificity');
subplot(2,2,2);bar([nanmean(info1_2),nanmean(info1_1)]);title('info1');
subplot(2,2,3);bar([nanmean(info2_2),nanmean(info2_1)]);title('info2');
subplot(2,2,4);bar([nanmean(spars_2),nanmean(spars_1)]);title('spars');

%%
nBins = 140;
for i=1:size(CA1pyr,1)
    s = GetSpikes(CA1pyr(i,:));
    for j=1:2
        [curve{i}{j},stats{i}{j}] = FiringCurve(posTrials{j},s,'nBins',nBins,'threshold',0.1,'minSize',14,'minPeak',2,'smooth',4); 
    end
    clear s;
end



