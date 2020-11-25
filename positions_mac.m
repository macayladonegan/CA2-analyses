function positions_mac(inputFile,smoothingChoice,varargin)
p.sChoice = smoothingChoice;

% Program parameters_______________________________________________________
% Bin width for the ratemap
p.binWidth = 1;
% Smoothing factor to be used in the rate map if optimal smoothing is not
% chosen.
p.smoothing = 1.1; %Default is 1.1 times p.bitWidth
% Smoothing values to be tested to find the optimal one. You can put as
% many values you want here, but remember that it takes some time to test
% each value.
%BELOW function not working as well. Use p.smoothing option like this
%spatialAutoCorrelation5('AxInfo.txt', 0)
p.smoothValues = [1.5, 3.0, 5.0, 7.5, 10, 15, 20, 30];
% Minimum number of bins in a placefield. Fields with fewer bins than this
% treshold will not be considered as a placefield. Remember to adjust this
% value when you change the bin width
p.minNumBins = 9;
% Bins with rate at 0.2 * peak rate and higher will be considered as part
% of a place field
p.fieldTreshold = 0.2;
% Lowest field rate in Hz.
p.lowestFieldRate = 1;

p.trajmap = 1;     % Use 1 for 2D map or 2 for 3D map [Default is 1]

p.plotratemap = 1; % Use 1 for 2D map or 2 for 3D map [Default is 1]

%p.gridscore = 2;
p.gridscore = 1;% Use 1 for Lukas's grid score or 2 for Moser lab's grid score [Default is 2]
                 % Lukas Solanka's grid score: http://gridcells.readthedocs.org/en/latest/index.html

% Low speed threshold. Segments of the path where the mouse moves slower
% than this threshold will be removed. Set it to zero (0) to keep
% everything. Value in centimeters per second.
p.lowSpeedThreshold = 3; % [cm/s]

% High speed threshold. Segments of the path where the mouse moves faster
% than this threshols will be removed. Set it to zero (0) to keep
% everything. Value in centimeters per second.
p.highSpeedThreshold = 0; % [cm/s]

%__________________________________________________________________________


% Directory to store the image files in (sub directory to the data directories)
p.imageDir = 'CorrelationImages\';

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

% Image format for autocorrelation images
p.pathAutocorrFormat = 3;


% DPI setting for the image file
p.dpi = 300;

%Import pos info from nlx
[VT1_TimeStamps,x,y,VT1_Targets,VT1_Header] = Nlx2MatVT('VT1.nvt',[1 1 1 0 1 0],1,1);
x1=x';x1(x1==0)=[];x1=smooth(x1);
y1=y';y1(y1==0)=[];y1=smooth(y1);
inds=find(x>0);
t=VT1_TimeStamps';t=t(inds);
qq=t(1);
for uu=1:length(t)
    t(uu)=t(uu)-qq;
end
t=t/1e+06;


     scale_x=range(x1)/65;
     x1=x1/scale_x;
     
     scale_y=range(y1)/41;
     y1=y1/scale_y;
    centre = centreBox(x1,y1);
    R.x1 = x1 - centre(1);
    R.y1 = y1 - centre(2);

    obsLength = max(max(x1)-min(x1),max(y1)-min(y1));
    bins = ceil(obsLength/p.binWidth);
    sLength = p.binWidth*bins;
    mapAxis = (-sLength/2+p.binWidth/2):p.binWidth:(sLength/2-p.binWidth/2);
    
    % Calulate what areas of the box that have been visited
    visited = visitedBins(x1,y1,mapAxis);

[vel, vel_timestamps, path]=velocity(x1,y1,t);
vel=smooth(vel);



%[x,y,t] = remBadTrack(x,y,VT1_TimeStamps,100/2000);

%Import ts from Ax, set params


% Open the input file for reading
fid1 = fopen(inputFile,'r');
if fid1 == -1
    msgbox('Could not open the input file! Make sure the filname and path are correct.','ERROR');
    return;
end


%Open the output file for writing
fid2 = fopen('Axoutput.txt','w');

%write header to outputfile
fprintf(fid2,'%s\t','Session(s)');
fprintf(fid2,'%s\t','Tetrode');
fprintf(fid2,'%s\t','Unit');
fprintf(fid2,'%s\t','Field');
fprintf(fid2,'%s\t','Field X');
fprintf(fid2,'%s\t','Field Y');
fprintf(fid2,'%s\t','Avg. rate session');
fprintf(fid2,'%s\t','Peak rate session');
fprintf(fid2,'%s\t','Field size (cm^2)');
fprintf(fid2,'%s\t','Avg. rate field');
fprintf(fid2,'%s\t','Peak rate field');
fprintf(fid2,'%s\t','Bursting (%)');
fprintf(fid2,'%s\t','Sparseness');
fprintf(fid2,'%s\t','Information');
fprintf(fid2,'%s\t','Selectivity');
fprintf(fid2,'%s\n','Z coherence');


disp(sprintf('%s%s','Read input data from: ',inputFile));
% Get data from the input file
while ~feof(fid1)
    % Flag indicating if we are combining sessions into on big session. 0 =
    % single session, 1 = combined sessions with joint cut file, 2 =
    % combined sessions with separate cut files
    combined = 0;
    % May have up to 10 combined session and cut files
    Xsessions = cell(10,1);
    Xcut = cell(10,1);
    Xcounter = 0;
    % Read first line of input file
    str = fgetl(fid1);
    if length(str)<7
        disp('Failed');
        msgbox('Missing data in input on session.');
        return
    end
    if ~strcmp(str(1:7),'Session') && ~strcmp(str(1:7),'session') && ~strcmp(str(1:7),'SESSION')
        disp('Failed');
        msgbox('Corrupted input file! Missing session data','Error');
        return
    else
        session = str(9:end);
        str = fgetl(fid1);
        % Make sure that the folder for storing images exist
        ind = strfind(session,'\');
        dirStr = strcat(session(1:ind(end)),p.imageDir);
        dirInfo = dir(dirStr);
        if isempty(dirInfo)
            % Make the image directory
            mkdir(dirStr);
        end
    end
    
    if strcmp(str(1:3),'Cut') || strcmp(str(1:7),'cut') || strcmp(str(1:7),'CUT')
        combined = 2;
        disp('Combined sessions with separate cut files detected')
        % Name for first cut file
        cutFile = str(5:end);
        % Read next line
        str = fgetl(fid1);
        % Read session and cut info as long as there are more in the input
        % file
        getSess = 1;
        while 1
            if getSess % Session or room info expected next
                if strcmp(str(1:7),'Session') || strcmp(str(1:7),'session') || strcmp(str(1:7),'SESSION')
                    Xcounter = Xcounter + 1;
                    Xsessions{Xcounter} = str(9:end);
                    getSess = 0;
                    str = fgetl(fid1);
                    % Make sure that the folder for storing images exist
                    ind = strfind(Xsessions{Xcounter},'\');
                    dirStr = strcat(Xsessions{Xcounter}(1:ind(end)),p.imageDir);
                    dirInfo = dir(dirStr);
                    if isempty(dirInfo)
                        % Make the image directory
                        mkdir(dirStr);
                    end
                else
                    % No more session, go to read the room information
                    break
                end
            else % Cut info expected next
                if strcmp(str(1:3),'cut') || strcmp(str(1:3),'Cut') || strcmp(str(1:3),'CUT')
                    Xcut{Xcounter} = str(5:end);
                    str = fgetl(fid1);
                    getSess = 1;
                else
                    msgbox('Missing cut file!','Error');
                    return;
                end
            end
        end
    end
    
    while strcmp(str(1:7),'Session') || strcmp(str(1:7),'session') || strcmp(str(1:7),'SESSION')
        % Sessions will be combined with joint cut file
        combined = 1;
        Xcounter = Xcounter + 1;
        Xsessions(Xcounter) = {str(9:end)};
        str = fgetl(fid1);
        % Make sure that the folder for storing images exist
        ind = strfind(Xsessions{Xcounter},'\');
        dirStr = strcat(Xsessions{Xcounter}(1:ind(end)),p.imageDir);
        dirInfo = dir(dirStr);
        if isempty(dirInfo)
            % Make the image directory
            mkdir(dirStr);
        end
    end
    if combined==1
        disp('Combined sessions with joint cut file detected');
        % Get shareed cut file for the combined sessions
        if strcmp(str(1:3),'cut') || strcmp(str(1:3),'Cut') || strcmp(str(1:3),'CUT')
            cutFile = str(5:end);
            str = fgetl(fid1);
        else
            msgbox('Missing cut file!','Error');
            return;
        end
    end
    
    % Get room information
    if length(str)<4
        msgbox('Missing room information','Error');
        return
    end
    if ~strcmp(str(1:4),'Room') && ~strcmp(str(1:4),'room') && ~strcmp(str(1:4),'ROOM')
        msgbox('Missing room information','Error');
        return
    else
        room = str(6:end);
        str = fgetl(fid1);
    end
     if length(str)<9
        msgbox('Missing tracking information','Error');
        return
    end
    if ~strcmp(str(1:8),'Tracking') && ~strcmp(str(1:8),'tracking') && ~strcmp(str(1:8),'TRACKING')
        msgbox('Missing tracking information','Error');
        return
    else
        tracking = str(10:end);
        str = fgetl(fid1);
    end

    if combined==0
        disp('Single session detected')
    end
    
    disp('Read input data')
    % Continue to read tetrode number
    while ~feof(fid1) && ~strcmp(str,'---')
        % Get tetrode number
        if length(str)<7
            disp('Failed');
            %msgbox('Missing data in input on tetrode.');
            return
        end
        if ~strcmp(str(1:7),'Tetrode') && ~strcmp(str(1:7),'tetrode') && ~strcmp(str(1:7),'TETRODE')
            disp('Failed');
            msgbox('Corrupted input file! Missing tetrode data','Error');
            return
        else
            tetrode = sscanf(str,'%*s %u');
            str = fgetl(fid1);
        end
        
        % Import data from cut file(s)
        if combined == 0
            %cutFile = sprintf('%s_%u.cut',session,tetrode);
            cutFile = sprintf('%s\\tint_6.cut',session);
            %cutFile = uigetfile;
            cut = getcut(cutFile);
        elseif combined == 1
            cut = getcut(cutFile);
        else
            % Read the separate cut files, and join them together
            cut = getcut(cutFile);
            for ii = 1:Xcounter
                cutTemp = getcut(Xcut{ii});
                cut = [cut; cutTemp];
            end
        end
            
              
        % Import data from spike files
        datafile = sprintf('%s\\tint.%u',session,tetrode);
        ts = getspikes(datafile);    
        if combined==1 || combined==2
            combTS = ts;
            for ii = 1:Xcounter
                datafile = sprintf('%s.%u',Xsessions{ii},tetrode);
                ts = getspikes(datafile);
                combTS = [combTS; ts+timeOffset(ii)];
            end
            ts = combTS;
        end

  
        %%%%% Abid Aug 18
       [pathstr,name] = fileparts(session);
       ext='.cut';
       ext2=('.mat');
       matfile=fullfile(pathstr,[name ext ext2]);
       save(matfile,'cut');
       
       recSystem='Axona';
       ext='.pos';
       ext2=('.mat');
       matfile=fullfile(pathstr,[name ext ext2]);
       save(matfile,'x1','y1','t','recSystem')
        
% Generate output filename
    %dirPath=session;
    ind = strfind(session,'\');
    dirPath = strcat(session(1:ind(end)),p.imageDir);
    namelength=(length(inputFile)-4); 
    corename=inputFile(3:namelength);
    outputFile = strcat('out-',corename,'.xls');
    outputFile = strcat('out-',corename,'.xls');
    outputFile = sprintf('%s%s%s',dirPath,corename,'.xls');
    
    [pathstr,name] = fileparts(session);
    outputFile = sprintf('%s%s%c%d%s',dirPath,name,'_',tetrode,'.xls');

       % Open the output file for writing
       fid2 = fopen(outputFile,'w');
     
      % write header to outputfile
        fprintf(fid2,'%s\t','Session(s)');
        fprintf(fid2,'%s\t','Tetrode');
        fprintf(fid2,'%s\t','Unit');
        fprintf(fid2,'%s\t','Field');
        fprintf(fid2,'%s\t','Field X');
        fprintf(fid2,'%s\t','Field Y');
        fprintf(fid2,'%s\t','Avg. rate session');
        fprintf(fid2,'%s\t','Peak rate session');
        fprintf(fid2,'%s\t','Field size (cm^2)');
        fprintf(fid2,'%s\t','Avg. rate field');
        fprintf(fid2,'%s\t','Peak rate field');
        fprintf(fid2,'%s\t','Bursting (%)');
        fprintf(fid2,'%s\t','Sparseness');
        fprintf(fid2,'%s\t','Information');
        fprintf(fid2,'%s\t','Selectivity');
        fprintf(fid2,'%s\n','Z coherence');  
        
        % Get unit numbers from the input file
        while length(str)>3 && (strcmp(str(1:4),'Unit') || strcmp(str(1:4),'unit') || strcmp(str(1:4),'UNIT'))
            unit = sscanf(str,'%*s %u');
            
            unitmat=find(cut==unit);
            ext='.unit';
            matfile=fullfile(pathstr,[name ext ext2]);
            save(matfile,'unitmat');
            
            % Call the main function that will start up the analysis
            %MACAYLA- see why this gives an error when cut is passed
            %through
            cut_log = cut==unit; 
            cut_log = cut_log(1:length(ts)); %to correct that cut is sometimes longer than ts
            mainFunc(x1,y1,t,ts(cut_log),session,tetrode,unit,mapAxis,fid2,visited,t,p);
            
            % Stop the while loop if we have reached the end of the input
            % file
            if feof(fid1)
                break
            end
            str = fgetl(fid1);
        end
    end
end

% Close the files
fclose(fid1);
fclose(fid2);
%close all;
disp('FINISHED!')
%__________________________________________________________________________
%
%                           Main function
%__________________________________________________________________________

function mainFunc(posx,posy,post,ts,session,tetrode,unit,mapAxis,fid2,visited,cPost,p)
disp(sprintf('%s%u%s%u%s%s','Analyzing cell ',unit,' on tetrode ',tetrode,' for session ',session));

bins = length(mapAxis);

ind = findstr(session,'\');
if ind(end) == length(session)
    sess = session(1:ind(end-1));
    sessionName = session(ind(end-1)+1:end);
else
    sess = session(1:ind(end));
    sessionName = session(ind(end)+1:end);
end


% Store plot to file
    ind = strfind(session,'\');
    dirPath = strcat(session(1:ind(end)),p.imageDir);
    session = session(ind(end)+1:end);
    fileName = sprintf('%s%s%s%u%s%u%s',dirPath,session,'_T',tetrode,'C',unit,'_Path');
    imageStore(figure(1),p.pathImageFormat,fileName,p.dpi);
    
% % Construct image file names
 bmpImage=  sprintf('%s%s%s%u%s%u%s',dirPath, session,'_T',tetrode,'C',unit,'_rateMap.bmp');
 epsImage = sprintf('%s%s%s%u%s%u%s',dirPath, session,'_T',tetrode,'C',unit,'_rateMap.eps');
 matImage = sprintf('%s%s%s%u%s%u%s',dirPath, session,'_T',tetrode,'C',unit,'_rateMap.fig');

if isempty(ts) % No spikes for this cell
    % Make an empty map
    map = zeros(bins,bins);
    nFields = 0;
    avgRate = 0;
    peakRate = 0;
    information = NaN;
    bursting = NaN;
    sparseness = NaN;
    selectivity = NaN;
    zCoherence = NaN;
    % Plot empty map and store it to file
    figure(2)
    drawfield(map,mapAxis,'jet',max(max(map)));
    axis image;
    axis off;
    set(gcf,'color',[1 1 1]);
    f = getframe(gcf);
    [pic, cmap] = frame2im(f);
    
    % Store plot to file
    ind = strfind(session,'\');
    dirPath = strcat(session(1:ind(end)),p.imageDir);
    session = session(ind(end)+1:end);
    imageStore(pic,p.pathImageFormat,bmpImage,p.dpi);
    imwrite(pic,bmpImage,'bmp');
    print('-depsc2',epsImage);
else
    % Average rate for the whole session
    avgRate = length(ts)/(max(cPost)-min(cPost));
    % Calculate the spike positions, removing spikes from areas where the
    % tracking is bad
    [spkx,spky,ts] = spikePos(ts,posx,posy,post,cPost);
    % Calculate the spike firing map
        %save spikes and pos into session directory
    tetrode=num2str(tetrode);
    tetrode=strcat('TT',tetrode);
    unit=num2str(unit);
    unit=strcat('unit',unit);
    Tetrodecell=strcat(tetrode,unit);

    mkdir(Tetrodecell);
    cd(Tetrodecell);
    
    
    figure(1)
    
    %MACAYLA: THIS IS THE CODE FOR THE SPIKE PLOTS THAT STEVE LIKES
    figure(1)
   
 
    if p.trajmap == 1
        plot(posx,posy,'color',[0.5,0.5,0.5]);
        hold on
        plot(spkx,spky,'.r')
        hold off
    else     
        %3D plot     
        plot3(posx,posy,post,'color',[0.5,0.5,0.5]);
        hold on
        plot3(spkx,spky,ts,'.r')
        hold off
    end
    saveas(figure(1),'spikePlot') 
    
    set(gcf,'color',[1 1 1]);
    axis square
    drawnow;
    
    fileName = sprintf('%s%s%s%u%s%u%s',dirPath,session,'_T',tetrode,'C',unit,'_Path');
    imageStore(figure(1),p.pathImageFormat,fileName,p.dpi);
         
          
    if p.sChoice == 1
        disp('Calculate optimal smoothing')
        p.smoothing = optimalSmoothing(ts,spkx,spky,posx,posy,post,p.smoothValues,mapAxis,p.sampRate);
    end
    % Calculate the rate map and position probability density function
    [map,pospdf] = ratemap(spkx,spky,posx,posy,post,p.smoothing,mapAxis,mapAxis);
    
    % Set unvisited parts of the box to NaN
    map(visited==0) = NaN;
    
    % Calculate field properties
    [nFields,fieldProp] = placefield(map,p,mapAxis);
    
    % Calculate the z-coherence
    zCoherence = fieldcohere(map);
    
    % Peak rate of rate map
    peakRate = nanmax(nanmax(map));
    
    pospdf(visited==0) = 0;
    % Calculate the information (shannon), sparseness and selectivity
    [information,sparseness,selectivity] = mapstat(map,pospdf);
    
    % Calculate the percentage of bursting
    [bursts,singleSpikes] = burstfinder(ts,0.01); % 10 ms criterion
    bursting = length(bursts)/(length(bursts)+length(singleSpikes));

    % Draw the map to screen
    figure(2)
    figure(2)
    if p.plotratemap == 1
        drawfield(map,mapAxis,'jet',max(max(map)),p.binWidth,p.smoothing);
       
    else
        surfc(map);
         
    end
    
    %set (gcf,'Renderer','opengl')
    set(gcf,'color',[1 1 1]);
    axis image;
    axis off;
    f = getframe(gcf);
    [pic, cmap] = frame2im(f);
    
    saveas(figure(2),'heatMap')
    
    fileName = sprintf('%s%s%s%u%s%u%s',dirPath,session,'_T',tetrode,'C',unit,'_Map');
    % Store the image
    imageStore(figure(2),p.mapImageFormat,fileName,p.dpi);
    
    save spks.mat
    cd ..
    %fileName = sprintf('%s%s%s%u%s%u%s',dirPath,session,'_T',tetrode,'C',unit,'_Spikes');
    %imageStore(pic,p.pathImageFormat,bmpImage,p.dpi);
    %imwrite(pic,bmpImage,'bmp'); %Save Bitmap image
    %print('-depsc2',epsImage);   %Save EPS image
    %hgsave(matImage);            %Save matlab fig file
    
%     disp('Calculating the auto-correlogram')
%     Rxx = correlation(map,map);
    
    
%     %% Grid Score
%     RxxCopy=Rxx;
%     
%     if p.gridscore == 1
%            
%         %RxxCopy=imrotate(Rxx,45,'nearest','loose'); %rotate image to maximum to get all area
%         width = size(RxxCopy,1);% Width
%         height = size(RxxCopy,2);% Height
%         radius = 10; % pixels to remove from center
%         centerW = width/2; % width center
%         centerH = height/2; % height center
%         [W,H] = meshgrid(1:width,1:height);
%         mask = sqrt((W-centerW).^2 + (H-centerH).^2) > radius; %mask center
%         RxxCopy=RxxCopy.*mask; % apply mask to image
%         %RxxCopy=imrotate(RxxCopy,-45,'nearest','crop'); % Rotate image back
%         RxxCopy(RxxCopy == 0) = NaN; %convert 0s to NaNs
%         RxxCopy(isnan(RxxCopy)) =  mean2(RxxCopy(~isnan(RxxCopy))); % convert nans to mean of image
% 
%         da=3; %rotation angle steps
%         angles=da:3:180;
%         crossCorr=[];
%         for angle = angles(1:end);
%         RotMap=imrotate(RxxCopy,angle,'nearest','crop');
%         C=corr2(RxxCopy,RotMap);
%         crossCorr=[crossCorr C];
%         end
% 
%         max_angles_i = [30, 90, 150] / da;
%         min_angles_i = [60, 120] / da;
%         maxima = max(crossCorr (max_angles_i))
%         minima = min(crossCorr(min_angles_i))
%         GridScore = minima - maxima
%         
%     else
%         GridScore = gridnessScore(RxxCopy)
%     end
    
%     %% Plot the auto-correlgoram
%     figure(3)
%     corrAxis = 1:size(Rxx,1);
%     Rxx = Rxx + 1;
%     drawCorrelation(Rxx,corrAxis,'jet',2)
%     titleStr = sprintf('%s%u%s%u%s%.2f','T',tetrode,' C',unit,'    GS:',GridScore);
%     title(titleStr)
%     fileName = sprintf('%s%s%s%u%s%u%s',dirPath,session,'_T',tetrode,'C',unit,'_Auto-Correlogram');
%     % Store the image
%     imageStore(figure(3),p.mapImageFormat,fileName,p.dpi);
    
end

    % Write results to file
if nFields==0
    fprintf(fid2,'%s\t',session);
    fprintf(fid2,'%u\t', tetrode);
    fprintf(fid2,'%u\t', unit);
    fprintf(fid2,'%u\t', 0);
    fprintf(fid2,'%u\t',NaN);
    fprintf(fid2,'%u\t',NaN);
    fprintf(fid2,'%3.2f\t',avgRate);
    fprintf(fid2,'%3.2f\t',peakRate);
    fprintf(fid2,'%u\t', 0);
    fprintf(fid2,'%u\t', NaN);
    fprintf(fid2,'%u\t', NaN);
    fprintf(fid2,'%3.2f\t',bursting);
    fprintf(fid2,'%3.2f\t',sparseness);
    fprintf(fid2,'%3.2f\t',information);
    fprintf(fid2,'%3.2f\t',selectivity);
    fprintf(fid2,'%3.2f\n',zCoherence);
else
    for ii = 1:nFields
        fprintf(fid2,'%s\t',session);
        fprintf(fid2,'%u\t', tetrode);
        fprintf(fid2,'%u\t', unit);
        fprintf(fid2,'%u\t', ii);
        fprintf(fid2,'%3.1f\t',fieldProp(ii).x);
        fprintf(fid2,'%3.1f\t',fieldProp(ii).y);
        fprintf(fid2,'%3.2f\t',avgRate);
        fprintf(fid2,'%3.2f\t',peakRate);
        fprintf(fid2,'%4.0f\t',fieldProp(ii).size);
        fprintf(fid2,'%3.2f\t',fieldProp(ii).avgRate);
        fprintf(fid2,'%3.2f\t',fieldProp(ii).peakRate);
        fprintf(fid2,'%3.2f\t',bursting);
        fprintf(fid2,'%3.2f\t',sparseness);
        fprintf(fid2,'%3.2f\t',information);
        fprintf(fid2,'%3.2f\t',selectivity);
        fprintf(fid2,'%3.2f\n',zCoherence);
    end
end


%__________________________________________________________________________
%
%                  Function for calculting optimal smoothing
%__________________________________________________________________________


% % Calculate optimal smoothing factor for the placefield using a 10-fold
% % cross-validation procedure.
% 
% ts            Spike timestamps
% spkx          X-coords for the spike positions
% spky          Y-coords for the spike positions
% posx          X-coords for positions
% posy          Y-coords for positions
% post          Position timestamps
% testValues    Array with test values for the smoothing factor
% mapAxis       Array with map axis values
% sampRate      Average sampling rate in the recording

% Created by Raymond Skjerpeng
function optSmooth = optimalSmoothing(ts,spkx,spky,posx,posy,post,testValues,mapAxis,sampRate)


% Make sure the arrays have the dimensions "turned the right way"
[dim1,dim2] = size(posx);
if dim2 > dim1
    posx = posx';
    posy = posy';
    post = post';
end

% Time duration for each position sample
sampTime = 1/sampRate;
% Number of samples in data
numSamp = length(post);
% Number of samples in each segment
segL = floor(numSamp/10);
% Number of bins for each dimension in the rate map
bins = length(mapAxis);
% Width of the bins in the rate map
binWidth = mapAxis(2)-mapAxis(1);
% Predictability
predictability = -inf;

for ii = 1:length(testValues)
    % Current smoothing value to be tested
    smooth = testValues(ii);
    % Do the 10-fold cross-validation for the current smoothing value
    predict = zeros(1,10);
    for jj = 1:10
        % Split data into a training (9/10 of data) set and a test set
        % (1/10 of data)
        switch jj
            case 1
                % Training set data (tr)
                trX = posx(segL+1:end);
                trY = posy(segL+1:end);
                trT = post(segL+1:end);
                trSpkX = spkx(ts>trT(1));
                trSpkY = spky(ts>trT(1));
                % Test set data (ts)
                tsX = posx(1:segL);
                tsY = posy(1:segL);
                tsT = post(1:segL);
                tsSpkX = spkx(ts<=tsT(end));
                tsSpkY = spky(ts<=tsT(end));
            case 10
                % Training set data (tr)
                trX = posx(1:9*segL);
                trY = posy(1:9*segL);
                trT = post(1:9*segL);
                trSpkX = spkx(ts<trT(end));
                trSpkY = spky(ts<trT(end));
                % Test set data (ts)
                tsX = posx(9*segL+1:end);
                tsY = posy(9*segL+1:end);
                tsT = post(9*segL+1:end);
                tsSpkX = spkx(ts>=tsT(1));
                tsSpkY = spky(ts>=tsT(1));
            otherwise
                % Traning set data (tr)
                trX = posx(1:(jj-1)*segL);
                trX = [trX; posx(jj*segL+1:end)];
                trY = posy(1:(jj-1)*segL);
                trY = [trY; posy(jj*segL+1:end)];
                trT = post(1:(jj-1)*segL);
                tsLimit1 = trT(end);
                trT = [trT; post(jj*segL+1:end)];
                tsLimit2 = post(jj*segL);
                trSpkX = spkx(ts<tsLimit1 | ts>tsLimit2);
                trSpkY = spky(ts<tsLimit1 | ts>tsLimit2);
                % Test set data (ts)
                tsX = posx((jj-1)*segL+1:jj*segL);
                tsY = posy((jj-1)*segL+1:jj*segL);
                tsT = post((jj-1)*segL+1:jj*segL);
                tsSpkX = spkx(ts>=tsLimit1 & ts<=tsLimit2);
                tsSpkY = spky(ts>=tsLimit1 & ts<=tsLimit2);
        end
        % Calculate the training map
        tMap = ratemap(trSpkX,trSpkY,trX,trY,trT,smooth,mapAxis,mapAxis);
        % Arrays that will contain intensity at each time (at each sample
        % point and each spike point of the test set)
        ft = zeros(1,length(tsX));
        fts = zeros(1,length(tsSpkX));
        startX = mapAxis(1)-binWidth/2;
        stopX = mapAxis(1)+binWidth/2;
        % Find the rates for the arrays
        for m = 1:bins
            startY = mapAxis(1)-binWidth/2;
            stopY = mapAxis(1)+binWidth/2;
            for n = 1:bins
                ft(tsX>=startX & tsX<stopX & tsY>=startY & tsY<stopY) = tMap(m,n);
                fts(tsSpkX>=startX & tsSpkX<stopX & tsSpkY>=startY & tsSpkY<stopY) = tMap(m);
                startY = startY + binWidth;
                stopY = stopY + binWidth;
            end
            startX = startX + binWidth;
            stopX = stopX + binWidth;
        end
        % Remove entries that are equal to zero
        fts = fts(fts~=0);
        % Calculate the log2 for the spike train estimated rates
        lFts = log2(fts);
        % Calculate best estimate of the integral of the rate data.
        intFt = sum(ft*sampTime);
        % Log-likelihood density for spike train
        LF = sum(lFts)-intFt;
        % Mean rate in the traning set
        meanRate = length(trSpkX)/((9/10)*numSamp*sampTime);
        intFt0 = length(ft)*meanRate*sampTime;
        % Log-likelihood density for spikes when using only mean rate
        LF0 = length(fts)*log2(meanRate)-intFt0;
        % Prediction value for this segment set
        predict(jj) = LF-LF0;
    end
    % Mean predictability for current smoothing factor
    predictabilityTemp = sum(predict)/(numSamp*sampTime);
    disp(sprintf('%s%3.1f%s%1.4f','Smoothing factor ',smooth,' gives predictability ',predictabilityTemp));
    % Check if this smoothing factor is better than what we allready have
    if predictabilityTemp > predictability
        % Current smoothing is the best so far
        predictability = predictabilityTemp;
        optSmooth = smooth;
    else
        if ii == length(testValues)
            disp(sprintf('%s%3.1f','Best smoothing was found to be ',optSmooth));
        else
            disp(sprintf('%s%3.1f%s','Best smoothing was found to be ',optSmooth,'. It is not necessary to test the rest of the values!'));
            return
        end
    end
end





%__________________________________________________________________________
%
%                       Statistic function
%__________________________________________________________________________

% Shannon information, sparseness, and selectivity  
function [information,sparsity,selectivity] = mapstat(map,posPDF);
n = size(map,1);
meanrate = nansum(nansum( map .* posPDF ));
meansquarerate = nansum(nansum( (map.^2) .* posPDF ));
if meansquarerate == 0
   sparsity = NaN;
else
sparsity = meanrate^2 / meansquarerate;
end
maxrate = max(max(map));
if meanrate == 0;
   selectivity = NaN;
else
   selectivity = maxrate/meanrate;
end
[i1, i2] = find( (map>0) & (posPDF>0) );  % the limit of x*log(x) as x->0 is 0 
if length(i1)>0
    akksum = 0;
    for i = 1:length(i1);
        ii1 = i1(i);
        ii2 = i2(i);
        akksum = akksum + posPDF(ii1,ii2) * (map(ii1,ii2)/meanrate) * log2( map(ii1,ii2) / meanrate ); 
    end
    information = akksum;
else
    information = NaN;
end


function [bursts,singlespikes] = burstfinder(ts,maxisi);
bursts = [];
singlespikes = [];
isi = diff(ts);
n = length(ts);
if isi(1) <= maxisi
   bursts = 1;
else
   singlespikes = 1;
end
for t = 2:n-1;
   if (isi(t-1)>maxisi) & (isi(t)<=maxisi)
      bursts = [bursts; t];
   elseif (isi(t-1)>maxisi) & (isi(t)>maxisi)
      singlespikes = [singlespikes; t];      
   end
end   
if (isi(n-1)>maxisi) 
    singlespikes = [singlespikes; n];      
end




function z = fieldcohere(map)
[n,m] = size(map);
tmp = zeros(n*m,2);
k=0;
for y = 1:n
    for x = 1:m
        k = k + 1;
        xstart = max([1,x-1]);
        ystart = max([1,y-1]);
        xend = min([m x+1]);
        yend = min([n y+1]);
        nn = sum(sum(isfinite(map(ystart:yend,xstart:xend)))) - isfinite(map(y,x));
        if (nn > 0)
            tmp(k,1) = map(y,x);
            tmp(k,2) = nansum([ nansum(nansum(map(ystart:yend,xstart:xend))) , -map(y,x) ]) / nn;
        else
            tmp(k,:) = [NaN,NaN];    
        end
    end
end
index = find( isfinite(tmp(:,1)) & isfinite(tmp(:,2)) );
if length(index) > 3
    cc = corrcoef(tmp(index,:));
    z = atanh(cc(2,1));
else
    z = NaN;
end

%__________________________________________________________________________
%
%           Function for setting the axis for drawing
%__________________________________________________________________________

function mapAxis = setMapAxis(posx,posy,mapAxis,binWidth)

% Check for asymmetri in the path. If so correct acount for it in
% mapAxis
minX = min(posx);
maxX = max(posx);
minY = min(posy);
maxY = max(posy);
if minX < mapAxis(1)
    nXtra = ceil(abs(minX-mapAxis(1))/binWidth);
else
    nXtra = 0;
end
if maxX > mapAxis(end)
    pXtra = ceil(abs(maxX-mapAxis(end))/binWidth);
else
    pXtra = 0;
end
if nXtra
    for nn =1:nXtra
        tmp = mapAxis(1) - binWidth;
        mapAxis = [tmp; mapAxis'];
        mapAxis = mapAxis';
    end
end
if pXtra
    tmp = mapAxis(end) + binWidth;
    mapAxis = [mapAxis'; tmp];
    mapAxis = mapAxis';
end

if minY < mapAxis(1)
    nXtra = ceil(abs(minX-mapAxis(1))/binWidth);
else
    nXtra = 0;
end
if maxY > mapAxis(end)
    pXtra = ceil(abs(maxX-mapAxis(end))/binWidth);
else
    pXtra = 0;
end
if nXtra
    for nn =1:nXtra
        tmp = mapAxis(1) - binWidth;
        mapAxis = [tmp; mapAxis'];
        mapAxis = mapAxis';
    end
end
if pXtra
    tmp = mapAxis(end) + binWidth;
    mapAxis = [mapAxis'; tmp];
    mapAxis = mapAxis';
end

% Put on 3 extra cm on each side.
mapAxis = [mapAxis(1)-1.5;mapAxis'];
mapAxis = [mapAxis; mapAxis(end)+1.5];
mapAxis = mapAxis';
mapAxis = [mapAxis(1)-1.5;mapAxis'];
mapAxis = [mapAxis; mapAxis(end)+1.5];
mapAxis = mapAxis';





%__________________________________________________________________________
%
%                           Field functions
%__________________________________________________________________________


% Calculates the rate map and the position probability density function (pospdf).
function [map,pospdf] = ratemap(spkx,spky,posx,posy,post,h,yAxis,xAxis)
invh = 1/h;
map = zeros(length(xAxis),length(yAxis));
pospdf = zeros(length(xAxis),length(yAxis));

yy = 0;
for y = yAxis
    yy = yy + 1;
    xx = 0;
    for x = xAxis
        xx = xx + 1;
        [map(yy,xx),pospdf(yy,xx)] = rate_estimator(spkx,spky,x,y,invh,posx,posy,post);
    end
end

% Normalize the pospdf (Should actually normalize the integral of the
% pospdf by dividing by total area too, but the functions making use of the 
% pospdf assume that this is not done (see mapstat()).
pospdf = pospdf ./ sum(sum(pospdf)); % Position Probability Density Function

% Calculate the rate for one position value
function [r,edge_corrector] = rate_estimator(spkx,spky,x,y,invh,posx,posy,post)
% edge-corrected kernel density estimator

conv_sum = sum(gaussian_kernel(((spkx-x)*invh),((spky-y)*invh)));
edge_corrector =  trapz(post,gaussian_kernel(((posx-x)*invh),((posy-y)*invh)));
%edge_corrector(edge_corrector<0.15) = NaN;
r = (conv_sum / (edge_corrector + 0.0001)) + 0.0001; % regularised firing rate for "wellbehavedness"
                                                       % i.e. no division by zero or log of zero
% Gaussian kernel for the rate calculation
function r = gaussian_kernel(x,y)
% k(u) = ((2*pi)^(-length(u)/2)) * exp(u'*u)
r = 0.15915494309190 * exp(-0.5*(x.*x + y.*y));



% placefield identifies the placefields in the firing map. It returns the
% number of placefields and the location of the peak within each
% placefield.
%
% map           Rate map
% pTreshold     Field treshold
% pBins         Minimum number of bins in a field
% mapAxis       The map axis
function [nFields,fieldProp] = placefield(map,p,mapAxis)

binWidth = mapAxis(2) - mapAxis(1);


% Counter for the number of fields
nFields = 0;
% Field properties will be stored in this struct array
fieldProp = [];


% Allocate memory to the arrays
[M,N] = size(map);
% Array that contain the bins of the map this algorithm has visited
visited = zeros(M,N);
nanInd = isnan(map);
visited(nanInd) = 1;
visited2 = visited;



% Go as long as there are unvisited parts of the map left
while ~prod(prod(visited))
    % Array that will contain the bin positions to the current placefield
    binsX = [];
    binsY = [];
    
    % Find the current maximum
    [peak,r] = max(map);
    [peak,pCol] = max(peak);
    pCol = pCol(1);
    pRow = r(pCol);
    
    % Check if peak rate is high enough
    if peak < p.lowestFieldRate
        break;
    end
    
    visited2(map<p.fieldTreshold*peak) = 1;
    % Find the bins that construct the peak field
    [binsX,binsY,visited2] = recursiveBins(map,visited2,[],[],pRow,pCol,N,M);
    
    

    if length(binsX)>=p.minNumBins % Minimum size of a placefield
        nFields = nFields + 1;
        % Find centre of mass (com)
        comX = 0;
        comY = 0;
        % Total rate
        R = 0;
        for ii = 1:length(binsX)
            R = R + map(binsX(ii),binsY(ii));
            comX = comX + map(binsX(ii),binsY(ii))*mapAxis(binsX(ii));
            comY = comY + map(binsX(ii),binsY(ii))*mapAxis(binsY(ii));
        end
        % Average rate in field
        avgRate = nanmean(nanmean(map(binsX,binsY)));
        % Peak rate in field
        peakRate = nanmax(nanmax(map(binsX,binsY)));
        % Size of field
        fieldSize = length(binsX) * binWidth^2;
        % Put the field properties in the struct array
        fieldProp = [fieldProp; struct('x',comY/R,'y',comX/R,'avgRate',avgRate,'peakRate',peakRate,'size',fieldSize)];
    end
    visited(binsX,binsY) = 1;
    map(visited2==1) = 0;
end


function [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii,jj,N,M)
% If outside boundaries of map -> return.
if ii<1 || ii>N || jj<1 || jj>M
    return;
end
% If all bins are visited -> return.
if prod(prod(visited))
    return;
end
if visited(ii,jj) % This bin has been visited before
    return;
else
    binsX = [binsX;ii];
    binsY = [binsY;jj];
    visited(ii,jj) = 1;
    % Call this function again in each of the 4 neighbour bins
    [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii,jj-1,N,M);
    [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii-1,jj,N,M);
    [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii,jj+1,N,M);
    [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii+1,jj,N,M);
end


% function [legalI,legalJ] = getLegals(visited,legalI,legalJ)
% % Current bin
% cI = legalI(1);
% cJ = legalJ(1);
% % Neigbour bins
% leftI   = cI-1;
% rightI  = cI+1;
% upI     = cI;
% downI   = cI;
% leftJ   = cJ;
% rightJ  = cJ;
% upJ     = cJ-1;
% downJ   = cJ+1;
% 
% % Check left
% if leftI >= 1 % Inside map
%     if visited(leftI,leftJ)==0 % Unvisited bin
%         if ~(length(find(legalI==leftI)) & length(find(legalJ==leftJ))) % Not part of the array yet
%             % Left bin is part of placefield and must be added
%             legalI = [legalI;leftI];
%             legalJ = [legalJ;leftJ];
%         end
%     end
% end
% % Check rigth
% if rightI <= size(visited,2) % Inside map
%     if visited(rightI,rightJ)==0 % Unvisited bin
%         if ~(length(find(legalI==rightI)) & length(find(legalJ==rightJ))) % Not part of the array yet
%             % Right bin is part of placefield and must be added
%             legalI = [legalI;rightI];
%             legalJ = [legalJ;rightJ];
%         end
%     end
% end
% % Check up
% if upJ >= 1 % Inside map
%     if visited(upI,upJ)==0 % Unvisited bin
%         if ~(length(find(legalI==upI)) & length(find(legalJ==upJ))) % Not part of the array yet
%             % Up bin is part of placefield and must be added
%             legalI = [legalI;upI];
%             legalJ = [legalJ;upJ];
%         end
%     end
% end
% % Check down
% if downJ <= size(visited,1) % Inside map
%     if visited(downI,downJ)==0 % Unvisited bin
%         if ~(length(find(legalI==downI)) & length(find(legalJ==downJ))) % Not part of the array yet
%             % Right bin is part of placefield and must be added
%             legalI = [legalI;downI];
%             legalJ = [legalJ;downJ];
%         end
%     end
% end


% Finds the position to the spikes
function [spkx,spky,newTs] = spikePos(ts,posx,posy,post,cPost)
N = length(ts);
spkx = zeros(N,1);
spky = zeros(N,1);
newTs = zeros(N,1);
count = 0;
for ii = 1:N
    tdiff = (post-ts(ii)).^2;
    %tdiff2 = (cPost-ts(ii)).^2;
    [m,ind] = min(tdiff);
    %[m2,ind2] = min(tdiff2);
    % Check if spike is in legal time sone
    %if m == m2
        count = count + 1;
        spkx(count) = posx(ind(1));
        spky(count) = posy(ind(1));
        newTs(count) = ts(ii);
   % end
end
spkx = spkx(1:count);
spky = spky(1:count);
newTs = newTs(1:count);

% Calculates what area of the map that has been visited by the rat
function visited = visitedBins(posx,posy,mapAxis)

binWidth = mapAxis(2)-mapAxis(1);

% Number of bins in each direction of the map
N = length(mapAxis);
visited = zeros(N);

for ii = 1:N
    for jj = 1:N
        px = mapAxis(ii);
        py = mapAxis(jj);
        distance = sqrt( (px-posx).^2 + (py-posy).^2 )/(2*binWidth);
        
        if min(distance) <= binWidth
            visited(jj,ii) = 1;
        end
    end
end

%__________________________________________________________________________
%
%                   Function for modifying the path
%__________________________________________________________________________

% Removes position "jumps", i.e position samples that imply that the rat is
% moving quicker than physical possible.
function [x,y,t] = remBadTrack(x,y,t,treshold)

% Indexes to position samples that are to be removed
remInd = [];

diffX = diff(x);
diffY = diff(y);
diffR = sqrt(diffX.^2 + diffY.^2);
ind = find(diffR > treshold);

if ind(end) == length(x)
    offset = 2;
else
    offset = 1;
end

for ii = 1:length(ind)-offset
    if ind(ii+1) == ind(ii)+1
        % A single sample position jump, tracker jumps out one sample and
        % then jumps back to path on the next sample. Remove bad sample.
        remInd = [remInd; ind(ii)+1];
        ii = ii+1;
        continue
    else
        % Not a single jump. 2 possibilities:
        % 1. Tracker jumps out, and stay out at the same place for several
        % samples and then jumps back.
        % 2. Tracker just has a small jump before path continues as normal,
        % unknown reason for this. In latter case the samples are left
        % untouched.
        idx = find(x(ind(ii)+1:ind(ii+1)+1)==x(ind(ii)+1));
        if length(idx) == length(x(ind(ii)+1:ind(ii+1)+1));
            remInd = [remInd; (ind(ii)+1:ind(ii+1)+1)'];
        end
    end
end
% Remove the samples
x(remInd) = [];
y(remInd) = [];
t(remInd) = [];


% If 1-5 positon samples are missing, this function will interpolate
% the missing samples. If more than 5 samples are missing in a row they are
% left as NaN.
function [x1,y1] = interporPos(x1,y1)

% Find the indexes to the missing samples, for the red tracking diode
ind = isnan(x1);
ind = find(ind==1);
N = length(ind);

if N == 0
    % No samples missing and we return
    return
end

% Set start and stop points for the loop
if ind(N) >= length(x1)-5
    endLoop = N-5;
else
    endLoop = N;
end
if ind(1) == 1
    startLoop = 2;
else
    startLoop = 1;
end

for ii = startLoop:endLoop
    if length(find(ind==ind(ii)+1)) == 0 & length(find(ind==ind(ii)-1))==0
        % Only one missing sample in a row
        x1(ind(ii)) = (x1(ind(ii)-1)+x1(ind(ii)+1))/2;
        y1(ind(ii)) = (y1(ind(ii)-1)+y1(ind(ii)+1))/2;
    else
        if length(find(ind==ind(ii)+2)) == 0 & length(find(ind==ind(ii)-1))==0
            % 2 missing samples in a row
            xDist = abs(x1(ind(ii)-1)-x1(ind(ii)+2));
            yDist = abs(y1(ind(ii)-1)-y1(ind(ii)+2));
            x1(ind(ii)) = x1(ind(ii)-1) + 1/3*xDist;
            y1(ind(ii)) = y1(ind(ii)-1) + 1/3*yDist;
            x1(ind(ii)+1) = x1(ind(ii)-1) + 2/3*xDist;
            y1(ind(ii)+1) = y1(ind(ii)-1) + 2/3*yDist;
            ii = ii+1;
        else
            if length(find(ind==ind(ii)+3)) == 0 & length(find(ind==ind(ii)-1))==0
                % 3 missing samples in a row
                xDist = abs(x1(ind(ii)-1)-x1(ind(ii)+3));
                yDist = abs(y1(ind(ii)-1)-y1(ind(ii)+3));
                x1(ind(ii)) = x1(ind(ii)-1) + 1/4*xDist;
                y1(ind(ii)) = y1(ind(ii)-1) + 1/4*yDist;
                x1(ind(ii)+1) = x1(ind(ii)-1) + 1/2*xDist;
                y1(ind(ii)+1) = y1(ind(ii)-1) + 1/2*yDist;
                x1(ind(ii)+2) = x1(ind(ii)-1) + 3/4*xDist;
                y1(ind(ii)+2) = y1(ind(ii)-1) + 3/4*yDist;
                ii = ii+2;
            else
                if length(find(ind==ind(ii)+4)) == 0 & length(find(ind==ind(ii)-1))==0
                    % 4 missing samples in a row
                    xDist = abs(x1(ind(ii)-1)-x1(ind(ii)+4));
                    yDist = abs(y1(ind(ii)-1)-y1(ind(ii)+4));
                    x1(ind(ii)) = x1(ind(ii)-1) + 1/5*xDist;
                    y1(ind(ii)) = y1(ind(ii)-1) + 1/5*yDist;
                    x1(ind(ii)+1) = x1(ind(ii)-1) + 2/5*xDist;
                    y1(ind(ii)+1) = y1(ind(ii)-1) + 2/5*yDist;
                    x1(ind(ii)+2) = x1(ind(ii)-1) + 3/5*xDist;
                    y1(ind(ii)+2) = y1(ind(ii)-1) + 3/5*yDist;
                    x1(ind(ii)+3) = x1(ind(ii)-1) + 4/5*xDist;
                    y1(ind(ii)+3) = y1(ind(ii)-1) + 4/5*yDist;
                    ii = ii+3;
                else
                    if length(find(ind==ind(ii)+5)) == 0 & length(find(ind==ind(ii)-1))==0
                        % 5 missing samples in a row
                        xDist = abs(x1(ind(ii)-1)-x1(ind(ii)+5));
                        yDist = abs(y1(ind(ii)-1)-y1(ind(ii)+5));
                        x1(ind(ii)) = x1(ind(ii)-1) + 1/6*xDist;
                        y1(ind(ii)) = y1(ind(ii)-1) + 1/6*yDist;
                        x1(ind(ii)+1) = x1(ind(ii)-1) + 2/6*xDist;
                        y1(ind(ii)+1) = y1(ind(ii)-1) + 2/6*yDist;
                        x1(ind(ii)+2) = x1(ind(ii)-1) + 3/6*xDist;
                        y1(ind(ii)+2) = y1(ind(ii)-1) + 3/6*yDist;
                        x1(ind(ii)+3) = x1(ind(ii)-1) + 4/6*xDist;
                        y1(ind(ii)+3) = y1(ind(ii)-1) + 4/6*yDist;
                        x1(ind(ii)+4) = x1(ind(ii)-1) + 5/6*xDist;
                        y1(ind(ii)+4) = y1(ind(ii)-1) + 5/6*yDist;
                        ii = ii+4;
                    end
                end
            end
        end
    end
end


% Find the centre of the box
function centre = centreBox(posx,posy)
% Find border values for path and box
maxX = max(posx);
minX = min(posx);
maxY = max(posy);
minY = min(posy);

% Set the corners of the reference box
NE = [maxX, maxY];
NW = [minX, maxY];
SW = [minX, minY];
SE = [maxX, minY];

% Get the centre coordinates of the box
centre = findCentre(NE,NW,SW,SE);

% Calculates the centre of the box from the corner coordinates
function centre = findCentre(NE,NW,SW,SE);

% The centre will be at the point of interception by the corner diagonals
a = (NE(2)-SW(2))/(NE(1)-SW(1)); % Slope for the NE-SW diagonal
b = (SE(2)-NW(2))/(SE(1)-NW(1)); % Slope for the SE-NW diagonal
c = SW(2);
d = NW(2);
x = (d-c+a*SW(1)-b*NW(1))/(a-b); % X-coord of centre
y = a*(x-SW(1))+c; % Y-coord of centre
centre = [x,y];



%__________________________________________________________________________
%
%           Function for fixing the position timestamps
%__________________________________________________________________________

function [didFix,fixedPost] = fixTimestamps(post)

% First time stamp in file
first = post(1);
% Number of timestamps
N = length(post);
uniqePost = unique(post);

if length(uniqePost)~=N
    disp('Position timestamps are corrected');
    didFix = 1;
    numZeros = 0;
    % Find the number of zeros at the end of the file
    while 1
        if post(end-numZeros)==0
            numZeros = numZeros + 1;
        else
            break;
        end
    end
    
    last = first + (N-1-numZeros) *0.02;
    fixedPost = first:0.02:last;
    fixedPost = fixedPost';
else
    didFix = 0;
    fixedPost = [];
end


%__________________________________________________________________________
%
%                           Import routines
%__________________________________________________________________________

function [posx,posy,post,sampRate] = getpos(posfile,colour,arena)
%  
%   [posx,posy,post] = getpos(posfile,colour,arena)
%
%   Copyright (C) 2004 Sturla Molden
%   Centre for the Biology of Memory
%   NTNU
%   Modified by Raymond Skjerpeng 2004

[tracker,trackerparam] = importvideotracker(posfile);
if (trackerparam.num_colours ~= 4)
    error('getpos requires 4 colours in video tracker file.');
end    
post = zeros(trackerparam.num_pos_samples,1);
sampRate = trackerparam.sample_rate;

N = size(tracker(1).xcoord,2);
if N == 2 % A two point tracking has been done 
    temp = zeros(trackerparam.num_pos_samples,4);
else % Normal tracking
    temp = zeros(trackerparam.num_pos_samples,8);
end
for ii = 1:trackerparam.num_pos_samples
    post(ii) = tracker(ii).timestamp;
    temp(ii,:) = [tracker(ii).xcoord tracker(ii).ycoord];
end

[didFix,fixedPost] = fixTimestamps(post);
if didFix
    post = fixedPost;
    disp('Continue to read data');
end

if N == 4
    switch colour
        case {'red LED'}
            posx = temp(:,1) + trackerparam.window_min_x;
            posy = temp(:,5) + trackerparam.window_min_y;
        case {'green LED'}
            posx = temp(:,2) + trackerparam.window_min_x;
            posy = temp(:,6) + trackerparam.window_min_y;
        case {'blue LED'}
            posx = temp(:,3) + trackerparam.window_min_x;
            posy = temp(:,7) + trackerparam.window_min_y;
        case {'black on white'}
            posx = temp(:,4) + trackerparam.window_min_x;
            posy = temp(:,8) + trackerparam.window_min_y;
        otherwise
            error(sprintf('unknown colour "%s"',colour));
    end    
end


if N == 2
    M = length(temp(:,1));
    n1 = sum(isnan(temp(:,1)));
    n2 = sum(isnan(temp(:,2)));
    if n1 > n2
        posx = temp(:,2);
        posy = temp(:,4);
    else
        posx = temp(:,1);
        posy = temp(:,3);
    end
end



%%%%% Sept 2012- Abid
set(0,'DefaultFigureVisible','off'); 
boxplot(posx);
h = findobj(gcf,'tag','Outliers');
yc = get(h,'YData');
outx=find(posx==yc(1));

boxplot(posy);
h = findobj(gcf,'tag','Outliers');
yc = get(h,'YData');
outy=find(posy==yc(1));

%Remove entire rows (Time shortened by number of rows removed, so donot use)
%posx(outx)=[];
%posy(outy)=[];
%post(outy)=[];


%Replace outliers with NaNs (Time remains the same)
posx(outx)=NaN;
posy(outy)=NaN;


set(0,'DefaultFigureVisible','on'); 


%%%%% Sept 2012- Abid


%%%%%% Feb 2013- Abid
%rotate A matrix by x*90 degrees
%rot90 (A,x)

% posx = rot90(posx,1);
% posy = rot90(posy,1);

%%%% ROTATE MATRIX by certain theta angle 
%%%% WORKS FINE but needs user input
% theta=90;
% clf;hold on
% plot(posx,posy);
% axis([0 512 0 512]);
% title('select rotation point');
% [x0,y0]=ginput(1);
% plot(x0,y0,'x','MarkerSize',10);
% 
% %Prompt user to input rotation
% prompt = {'Enter Angle(in degrees) to rotate arena:'};
% dlg_title = 'Enter angle';
% num_lines = 1;
% def = {'90'};
% theta = inputdlg(prompt,dlg_title,num_lines,def);
% theta=str2double(theta);
% 
% % x0=250;
% % y0=250;
% 
% %hp=plot(nan,nan,'r');
% posx=posx-x0;posy=posy-y0;
% r = [cosd(theta) sind(theta); -sind(theta) cosd(theta)];
% xyr=[];
% for ii=1:numel(posx),xyr=[xyr r*[posx(ii);posy(ii)]];end
% posx1 = xyr(1,:)+x0;
% posy1 = xyr(2,:)+y0;
% plot(posx1,posy1,'Color','red')
% close all;
% posx=posx1;
% posy=posy1;
% 

% 
% %%%Previous step transposes vector into columns, rot90 function transposes
% %%%back to row format
% posx = rot90(posx,1);
% posy = rot90(posy,1);


numPos = length(posx);
numPost = length(post);
if numPos ~= numPost
    posx = posx(1:numPost);
    posy = posy(1:numPost);
end

% index = find ( (posx==0) & (posy==511) ); % this is internal to CBM's equipment.
% posx(index) = NaN;                        % 
% posy(index) = NaN;                        % 


if (nargin > 2)
    [posx, posy] = arena_config(posx,posy,arena);
end
post = post - post(1);

% Remove NaN in position if these appear at the end of the file
[posx,posy,post] = removeNaN(posx,posy,post);



function [posx, posy] = arena_config(posx,posy,arena)
switch arena
    case 'room0'
        centre = [433, 256];
        conversion = 387;
    case 'room1'
        centre = [421, 274];
        conversion = 403;
    case 'room2'
        centre = [404, 288];
        conversion = 400;
    case 'room3'
        centre = [356, 289]; % 2. Nov 2004
        conversion = 395;
    case 'room4'
        centre = [418, 186]; % 2. Nov 2004
        conversion = 313;
    case 'room5'
        centre = [406, 268]; % 2. Nov 2004
        conversion = 317;   % 52 cm abow floor, Color camera
    case 'room5bw'
        centre = [454,192]; % 2. Nov 2004
        conversion = 314;   % 52 cm abow floor, Black/White camera
    case 'room5floor'
        centre = [422,266]; % 2. Nov 2004
        conversion = 249;   % On floor, Color camera
    case 'room5bwfloor'
        centre = [471,185]; % 2. Nov 2004
        conversion = 249;   % On floor, Black/White camera
    case 'room6'
        centre = [402,292]; % 1. Nov 2004
        conversion = 398;
    case 'room7'
        centre = [360,230]; % 11. Oct 2004
        conversion = 351;
    case 'room8'
        centre = [390,259]; % Color camera
        conversion = 475;   % January 2006, 52 cm abow floor, 
    case 'room8bw'
        centre = [383,273]; % 11. Oct 2004
        conversion = 391;   % 66 cm abow floor, Black/White camera
    case 'room9'
        centre = [393,290];
        conversion = 246;
    case 'room10'
        centre = [385,331];
        conversion = 247;
    case 'roomCU1'
        centre = [385,331]; % 2. Nov 2012 %%Abid
        conversion = 240;   % Color camera
    otherwise
        disp('Unknown room info.')
        return
end
posx = 100 * (posx - centre(1))/conversion;
posy = 100 * (centre(2) - posy)/conversion;


function [posx,posy,post] = removeNaN(posx,posy,post)

while 1
    if isnan(posx(end)) | isnan(posy(end))
        posx(end) = [];
        posy(end) = [];
        post(end) = [];
    else
        break;
    end
end


function [tracker,trackerparam] = importvideotracker(filename)
%
%   [tracker,trackerparam] = importvideotracker(filename)
%   
%   Copyright (C) 2004 Sturla Molden 
%   Centre for the Biology of Memory
%   NTNU
%

%fid = fopen(filename,'r','ieee-be');
fid = fopen(filename);
if (fid < 0)
   error(sprintf('Could not open %s\n',filename)); 
end    

% read all bytes, look for 'data_start'
fseek(fid,0,-1);
sresult = 0;
[bytebuffer, bytecount] = fread(fid,inf,'uint8');
for ii = 10:length(bytebuffer)
    if strcmp( char(bytebuffer((ii-9):ii))', 'data_start' )
        sresult = 1;
        headeroffset = ii;
        break;
    end
end
if (~sresult)
    fclose(fid);
    error(sprintf('%s does not have a data_start marker', filename));
end

% count header lines
fseek(fid,0,-1);
headerlines = 0;
while(~feof(fid))
    txt = fgetl(fid);
    tmp = min(length(txt),10);
    if (length(txt))
        if (strcmp(txt(1:tmp),'data_start'))
            break;
        else
            headerlines = headerlines + 1;
        end
    else
        headerlines = headerlines + 1;
    end   
end    


% find time base
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^timebase.*')))
        timebase = sscanf(txt,'%*s %d %*s');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Timebase not reported, defaulting to 50 Hz');   
    timebase = 50;    
end

% find sample rate
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^sample_rate.*')))
        sample_rate = sscanf(txt,'%*s %d %*s');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Timebase not reported, defaulting to 50 Hz');   
    sample_rate = 50;    
end

% find duration
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^duration.*')))
        duration = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Duration not reported, defaulting to last time stamp');   
    duration = inf;    
end

% find number of samples
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^num_pos_samples.*')))
        num_pos_samples = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Number of samples not reported, using all that can be found');   
    num_pos_samples = inf;    
end

% find number of colours
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^num_colours .*')))
        num_colours  = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Number of colours not reported, defaulting to 4');   
    num_colours = 4;    
end

% find bytes per coord
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^bytes_per_coord.*')))
        bytes_per_coord = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Bytes per coordinate not reported, defaulting to 1');   
    bytes_per_coord = 1;    
end

% find bytes per timestamp
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^bytes_per_timestamp.*')))
        bytes_per_timestamp = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Bytes per timestamp not reported, defaulting to 4');   
    bytes_per_timestamp = 4;    
end

% find window_min_x
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^window_min_x.*')))
        window_min_x = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Minimum x-value for tracker window not reported, defaulting to 0');   
    window_min_x = 0;    
end

% find window_min_y
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^window_min_y.*')))
        window_min_y = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Minimum y-value for tracker window not reported, defaulting to 0');   
    window_min_y = 0;    
end

% find window_max_x
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^window_max_x.*')))
        window_max_x = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Maximum x-value for tracker window not reported, defaulting to 767 (PAL)');   
    window_max_x = 767;    
end

% find window_max_y
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^window_max_y.*')))
        window_max_y = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Maximum y-value for tracker window not reported, defaulting to 575 (PAL)'); 
    window_max_y = 575;    
end

% check position format
pformat = '^pos_format t';
for ii = 1:num_colours
    pformat = strcat(pformat,sprintf(',x%u,y%u',ii,ii));
end    
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^pos_format.*')))
        if (length(regexp(txt,pformat)))
            sresult = 1;
            twospot = 0;
            break;
        elseif (length(regexp(txt,'^pos_format t,x1,y1,x2,y2,numpix1,numpix2')))     
            sresult = 1;
            twospot = 1;
            break;
        else
           fclose(fid);
           fprintf(1,'%s\n',txt);
           error(sprintf('Unexpected position format, cannot read positions from %s',filename));   
        end
    end
end    
if (~sresult)
    fclose(fid);
    error(sprintf('No position format reported, cannot read positions from %s.\nAre you sure this is a video tracker file?',filename));   
end

% close the file
fclose(fid);

% count the number of positions in the file
if strcmp(char(bytebuffer(bytecount-11:bytecount))',sprintf('\r\ndata_end\r\n')) 
    tailoffset = 12; % <CR><LF>data_end<CR><LF>
else
    tailoffset = 0;
    warning('<CR><LF>data_end<CR><LF> not found at eof, did Dacq crash?n');
end    
if twospot
    poslen = bytes_per_timestamp + (4*bytes_per_coord + 8);
else    
    poslen = bytes_per_timestamp + (num_colours * 2 * bytes_per_coord);
end

num_samples_in_file = floor((bytecount - headeroffset - tailoffset)/poslen);  
if (isfinite(num_pos_samples))
    if (num_samples_in_file > num_pos_samples)
        warning(sprintf('%d spikes reported in header, but %s seems to contain %d positions.',num_pos_samples,filename,num_samples_in_file));
    elseif (num_samples_in_file < num_pos_samples)
        warning(sprintf('%d spikes reported in header, but %s can contain %d positions.',num_pos_samples,filename,num_samples_in_file));
        num_pos_samples = num_samples_in_file;    
    end
else
    num_pos_samples = num_samples_in_file;
end
    
% allocate memory for return values
if twospot
    posstruct = struct('timestamp',0,'xcoord',zeros(2,1),'ycoord',zeros(2,1),'numpix1',[],'numpix2',[]);
else
    posstruct = struct('timestamp',0,'xcoord',zeros(num_colours,1),'ycoord',zeros(num_colours,1));
end
tracker = repmat(posstruct,num_pos_samples,1);

% put the positions into the struct, one by one
big_endian_vector =  (256.^((bytes_per_timestamp-1):-1:0))';
big_endian_matrix = repmat((256.^((bytes_per_coord-1):-1:0))',1,num_colours*2);
if twospot
    big_endian_matrix_np = repmat((256.^(3:-1:0))',1,2);
    big_endian_matrix = repmat((256.^((bytes_per_coord-1):-1:0))',1,4);
end
for ii = 1:num_pos_samples
   % sort the bytes for this spike
   posoffset = headeroffset + (ii-1)*poslen;
   t_bytes = bytebuffer((posoffset+1):(posoffset+bytes_per_timestamp));
   tracker(ii).timestamp  = sum(t_bytes .* big_endian_vector) / timebase; % time stamps are big endian
   posoffset = posoffset + bytes_per_timestamp;
   if twospot
      c_bytes = reshape( bytebuffer((posoffset+1):(posoffset+(4*bytes_per_coord))), bytes_per_coord, 4); 
      tmp_coords =  sum(c_bytes .* big_endian_matrix, 1); % tracker data are big endian
      tracker(ii).xcoord = tmp_coords(1:2:end);
      index = find(tracker(ii).xcoord == 1023);
      tracker(ii).xcoord(index) = NaN; 
      tracker(ii).ycoord = tmp_coords(2:2:end);
      index = find(tracker(ii).ycoord == 1023);
      tracker(ii).ycoord(index) = NaN; 
      posoffset = posoffset + 4*bytes_per_coord;
      np_bytes = reshape( bytebuffer((posoffset+1):(posoffset+8)), 4, 2); 
      tmp_np = sum(np_bytes .* big_endian_matrix_np, 1);
      tracker(ii).numpix1 = tmp_np(1);
      tracker(ii).numpix2 = tmp_np(2);
      posoffset = posoffset + 8;
   else    
      c_bytes = reshape( bytebuffer((posoffset+1):(posoffset+(num_colours*2*bytes_per_coord))) , bytes_per_coord, num_colours*2); 
      tmp_coords =  sum(c_bytes .* big_endian_matrix, 1); % tracker data are big endian
      tracker(ii).xcoord = tmp_coords(1:2:end);
      index = find(tracker(ii).xcoord == 1023);
      tracker(ii).xcoord(index) = NaN; 
      tracker(ii).ycoord = tmp_coords(2:2:end);
      index = find(tracker(ii).ycoord == 1023);
      tracker(ii).ycoord(index) = NaN; 
   end
end
if (~isfinite(duration))
    duration = ceil(tracker(end).timestamp);
end

trackerparam = struct('timebase',timebase,'sample_rate',sample_rate,'duration',duration, ...
                  'num_pos_samples',num_pos_samples,'num_colours',num_colours,'bytes_per_coord',bytes_per_coord, ...
                  'bytes_per_timestamp',bytes_per_timestamp,'window_min_x',window_min_x,'window_min_y',window_min_y, ...
                  'window_max_x',window_max_x,'window_max_y',window_max_y,'two_spot',twospot);

              
                  
function clust = getcut(cutfile)
fid = fopen(cutfile, 'rt');
clust = [];
while ~feof(fid)
    string = fgetl(fid);
    if (length(string))
    if (string(1) == 'E') 
        break;
    end
    end
end
while ~feof(fid)
  string = fgetl(fid);
  if length(string)
     content = sscanf(string,'%u')';
     clust = [clust content];
  end
end
fclose(fid);
clust = clust';


%SPEED MODULATION
% Calculate the Speed of the rat in each position sample
%
% Version 1.0
% 3. Mar. 2008
% (c) Raymond Skjerpeng, CBM, NTNU, 2008.
function v = speed2D(x,y,t)

N = length(x);
v = zeros(N,1);

for ii = 2:N-1
    v(ii) = sqrt((x(ii+1)-x(ii-1))^2+(y(ii+1)-y(ii-1))^2)/(t(ii+1)-t(ii-1));
end
v(1) = v(2);
v(end) = v(end-1);

% Calculate the velocity in the x-data
%
% Version 1.0, 2007.
% (c) Raymond Skjerpeng, 2007.
function v = velocityLinear(x,t)

N = length(x);
v = zeros(N,1);

for ii = 2:N-1
    v(ii) = abs(x(ii+1)-x(ii-1))/(t(ii+1)-t(ii-1));
end

%SPEED MODULATION


function [ts,ch1,ch2,ch3,ch4] = getspikes(filename)
%
%   [ts,ch1,ch2,ch3,ch4] = getspikes(filename)
%   
%   Copyright (C) 2004 Sturla Molden 
%   Centre for the Biology of Memory
%   NTNU
%

[spikes,spikeparam] = importspikes(filename);
ts = [spikes.timestamp1]';
nspk = spikeparam.num_spikes;
spikelen = spikeparam.samples_per_spike;
ch1 = reshape([spikes.waveform1],spikelen,nspk)';
ch2 = reshape([spikes.waveform2],spikelen,nspk)';
ch3 = reshape([spikes.waveform3],spikelen,nspk)';
ch4 = reshape([spikes.waveform4],spikelen,nspk)';


function [spikes,spikeparam] = importspikes(filename)
%
%   [spikes,spikeparam] = importspikes(filename)
%   
%   Copyright (C) 2004 Sturla Molden 
%   Centre for the Biology of Memory
%   NTNU
%

fid = fopen(filename,'r','ieee-be');
if (fid < 0)
   error(sprintf('Could not open %s\n',filename)); 
end    

% read all bytes, look for 'data_start'
fseek(fid,0,-1);
sresult = 0;
[bytebuffer, bytecount] = fread(fid,inf,'uint8');
for ii = 10:length(bytebuffer)
    if strcmp( char(bytebuffer((ii-9):ii))', 'data_start' )
        sresult = 1;
        headeroffset = ii;
        break;
    end
end
if (~sresult)
    fclose(fid);
    error(sprintf('%s does not have a data_start marker', filename));
end

% count header lines
fseek(fid,0,-1);
headerlines = 0;
while(~feof(fid))
    txt = fgetl(fid);
    tmp = min(length(txt),10);
    if (length(txt))
        if (strcmp(txt(1:tmp),'data_start'))
            break;
        else
            headerlines = headerlines + 1;
        end
    else
        headerlines = headerlines + 1;
    end   
end    

% find timebase
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^timebase.*')))
        timebase = sscanf(txt,'%*s %d %*s');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Timebase not reported, defaulting to 96 kHz');   
    timebase = 96000;    
end

% find duration
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^duration.*')))
        duration = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Duration not reported, defaulting to last time stamp');   
    duration = inf;    
end

% find number of spikes
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^num_spikes.*')))
        num_spikes = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Number of spikes not reported, using all that can be found');   
    num_spikes = inf;    
end

% find bytes per sample
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^bytes_per_sample.*')))
        bytes_per_sample = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Bytes per sample not reported, defaulting to 1');   
    bytes_per_sample = 1;    
end

% find bytes per timestamp
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^bytes_per_timestamp.*')))
        bytes_per_timestamp = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Bytes per timestamp not reported, defaulting to 4');   
    bytes_per_timestamp = 4;    
end

% find samples per spike
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^samples_per_spike.*')))
        samples_per_spike = sscanf(txt,'%*s %d');    
        sresult = 1;
        break;
    end
end    
if (~sresult)
    warning('Samples per spike not reported, defaulting to 50');   
    samples_per_spike = 50;    
end

% check spike format
fseek(fid,0,-1);
sresult = 0;
for cc = 1:headerlines
    txt = fgetl(fid);
    if (length(regexp(txt,'^spike_format.*')))
        if (length(regexp(txt,'^spike_format t,ch1,t,ch2,t,ch3,t,ch4')))
            sresult = 1;
            break;
        else
           fclose(fid);
           error(sprintf('Unknown spike format, cannot read spikes from %s',filename));   
        end
    end
end    
if (~sresult)
    fclose(fid);
    error(sprintf('No spike format reported, cannot read spikes from %s.\nAre you sure this is a spike file?',filename));   
end

% close the file
fclose(fid);

% count the number of spikes in the file
spikelen = 4 * (bytes_per_sample * samples_per_spike + bytes_per_timestamp);
num_spikes_in_file = floor((bytecount - headeroffset)/spikelen);
if (isfinite(num_spikes))
    if (num_spikes_in_file > num_spikes)
        warning(sprintf('%d spikes reported in header, but %s seems to contain %d spikes.',num_spikes,filename,num_spikes_in_file));
    elseif (num_spikes_in_file < num_spikes)
        warning(sprintf('%d spikes reported in header, but %s can contain have %d spikes.',num_spikes,filename,num_spikes_in_file));
        num_spikes = num_spikes_in_file;    
    end
else
    num_spikes = num_spikes_in_file;
end
    
% allocate memory for return values

spikestruct = struct('timestamp1',0,'waveform1',zeros(samples_per_spike,1), ...
                     'timestamp2',0,'waveform2',zeros(samples_per_spike,1), ...
                     'timestamp3',0,'waveform3',zeros(samples_per_spike,1), ...
                     'timestamp4',0,'waveform4',zeros(samples_per_spike,1));

spikes = repmat(spikestruct,num_spikes,1);
                        
% out the spikes into the struct, one by one

big_endian_vector =  (256.^((bytes_per_timestamp-1):-1:0))';
little_endian_matrix = repmat(256.^(0:(bytes_per_sample-1))',1,samples_per_spike);

for ii = 1:num_spikes
   % sort the bytes for this spike
   spikeoffset = headeroffset + (ii-1)*spikelen;
   t1_bytes = bytebuffer((spikeoffset+1):(spikeoffset+bytes_per_timestamp));
   spikeoffset = spikeoffset + bytes_per_timestamp;
   w1_bytes = bytebuffer((spikeoffset+1):(spikeoffset+(bytes_per_sample*samples_per_spike)));
   w1_bytes( w1_bytes > 127 ) = w1_bytes( w1_bytes > 127 ) - 256;
   w1_bytes = reshape(w1_bytes,bytes_per_sample,samples_per_spike);
   spikeoffset = spikeoffset + bytes_per_sample*samples_per_spike;
   t2_bytes = bytebuffer((spikeoffset+1):(spikeoffset+bytes_per_timestamp));
   spikeoffset = spikeoffset + bytes_per_timestamp;
   w2_bytes = bytebuffer((spikeoffset+1):(spikeoffset+(bytes_per_sample*samples_per_spike)));
   w2_bytes( w2_bytes > 127 ) = w2_bytes( w2_bytes > 127 ) - 256;
   w2_bytes = reshape(w2_bytes,bytes_per_sample,samples_per_spike);
   spikeoffset = spikeoffset + bytes_per_sample*samples_per_spike;
   t3_bytes = bytebuffer((spikeoffset+1):(spikeoffset+bytes_per_timestamp));
   spikeoffset = spikeoffset + bytes_per_timestamp;
   w3_bytes = bytebuffer((spikeoffset+1):(spikeoffset+(bytes_per_sample*samples_per_spike)));
   w3_bytes( w3_bytes > 127 ) = w3_bytes( w3_bytes > 127 ) - 256;
   w3_bytes = reshape(w3_bytes,bytes_per_sample,samples_per_spike);
   spikeoffset = spikeoffset + bytes_per_sample*samples_per_spike;
   t4_bytes = bytebuffer((spikeoffset+1):(spikeoffset+bytes_per_timestamp));
   spikeoffset = spikeoffset + bytes_per_timestamp;
   w4_bytes = bytebuffer((spikeoffset+1):(spikeoffset+(bytes_per_sample*samples_per_spike)));
   w4_bytes( w4_bytes > 127 ) = w4_bytes( w4_bytes > 127 ) - 256;
   w4_bytes = reshape(w4_bytes,bytes_per_sample,samples_per_spike);
   % interpret the bytes for this spike
   spikes(ii).timestamp1 = sum(t1_bytes .* big_endian_vector) / timebase; % time stamps are big endian
   spikes(ii).timestamp2 = sum(t2_bytes .* big_endian_vector) / timebase;
   spikes(ii).timestamp3 = sum(t3_bytes .* big_endian_vector) / timebase;
   spikes(ii).timestamp4 = sum(t4_bytes .* big_endian_vector) / timebase;
   spikes(ii).waveform1 =  sum(w1_bytes .* little_endian_matrix, 1); % signals are little-endian
   spikes(ii).waveform2 =  sum(w2_bytes .* little_endian_matrix, 1);
   spikes(ii).waveform3 =  sum(w3_bytes .* little_endian_matrix, 1);
   spikes(ii).waveform4 =  sum(w4_bytes .* little_endian_matrix, 1);
end
if (~isfinite(duration))
    duration = ceil(spikes(end).timestamp1);
end
spikeparam = struct('timebase',timebase,'bytes_per_sample',bytes_per_sample,'samples_per_spike',samples_per_spike, ...
                    'bytes_per_timestamp',bytes_per_timestamp,'duration',duration,'num_spikes',num_spikes);



%__________________________________________________________________________
%%
%                       Correlation function
%__________________________________________________________________________


% Calculates the auto-correlation. Map1 and map2 is the same map. Must
% adjust this function for calculating cross-correlation.
function Rxy = correlation(map1,map2)

% Number of bins in each dimension of the rate map
numBins = size(map1,1);

% Number of correlation bins
numCorrBins = numBins * 2 - 1;

% Index for the centre bin in the correlation map
centreBin = (numCorrBins+1)/2;

% Allocate memory for the cross-correlation map
Rxy = zeros(numCorrBins);

for hLag = 0:numBins-1
    for vLag = 0:numBins-1
        
        % Calculate the mean firing area in the correlation area of the
        % maps
        xMean = 0;
        yMean = 0;
        xMean2 = 0;
        yMean2 = 0;
        meanCounter = 0;
        meanCounter2 = 0;
        for ii = 1:numBins-hLag
            for jj = 1:numBins-vLag
                if ~isnan(map1(ii,jj)) && ~isnan(map2(ii+hLag,jj+vLag))
                    xMean = xMean + map1(ii,jj);
                    yMean = yMean + map2(ii+hLag,jj+vLag);
                    meanCounter = meanCounter + 1;
                end
                if ~isnan(map1(ii,jj+vLag)) && ~isnan(map2(ii+hLag,jj))
                    xMean2 = xMean2 + map1(ii,jj+vLag);
                    yMean2 = yMean2 + map2(ii+hLag,jj);
                    meanCounter2 = meanCounter2 + 1;
                end
            end
        end
        xMean = xMean / meanCounter;
        yMean = yMean / meanCounter;
        xMean2 = xMean2 / meanCounter2;
        yMean2 = yMean2 / meanCounter2;
        
        nominator = 0;
        nominator2 = 0;
        xx = 0;
        xx2 = 0;
        yy = 0;
        yy2 = 0;
        for ii = 1:numBins-hLag
            for jj = 1:numBins-vLag
                if ~isnan(map1(ii,jj)) && ~isnan(map2(ii+hLag,jj+vLag))
                    nominator = nominator + (map1(ii,jj)-xMean) * (map2(ii+hLag,jj+vLag)-yMean);
                    xx = xx + (map1(ii,jj)-xMean)^2;
                    yy = yy + (map2(ii+hLag,jj+vLag)-yMean)^2;
                end
                if ~isnan(map1(ii,jj+vLag)) && ~isnan(map2(ii+hLag,jj))
                    nominator2 = nominator2 + (map1(ii,jj+vLag)-xMean2) * (map2(ii+hLag,jj)-yMean2);
                    xx2 = xx2 + (map1(ii,jj+vLag)-xMean2)^2;
                    yy2 = yy2 + (map2(ii+hLag,jj)-yMean2)^2;
                end
            end
        end
        denominator = sqrt(xx)*sqrt(yy);
        Rxy(centreBin-hLag,centreBin-vLag) = nominator/denominator;
        Rxy(centreBin+hLag,centreBin+vLag) = Rxy(centreBin-hLag,centreBin-vLag);
        
        denominator = sqrt(xx2)*sqrt(yy2);
        Rxy(centreBin+hLag,centreBin-vLag) = nominator2/denominator;
        Rxy(centreBin-hLag,centreBin+vLag) = Rxy(centreBin+hLag,centreBin-vLag);
        
    end
end


%%
function drawCorrelation(map,faxis,cmap,maxrate)
   
   % This function will calculate an RGB image from the rate
   % map. We do not just call image(map) and caxis([0 maxrate]),
   % as it would plot unvisted parts with the same colour code
   % as 0 Hz firing rate. Instead we give unvisited bins
   % their own colour (e.g. gray or white).

   maxrate = ceil(maxrate);
   if maxrate < 1
      maxrate = 1;
   end
   n = size(map,1);
   plotmap = ones(n,n,3);
   for jj = 1:n
      for ii = 1:n
         if isnan(map(jj,ii))
            plotmap(jj,ii,1) = 1; % give the unvisited bins a gray colour
            plotmap(jj,ii,2) = 1;
            plotmap(jj,ii,3) = 1;
         else
            rgb = pixelcolour(map(jj,ii),maxrate,cmap);
            plotmap(jj,ii,1) = rgb(1);
            plotmap(jj,ii,2) = rgb(2);
            plotmap(jj,ii,3) = rgb(3);
         end
      end
   end
   image(faxis,faxis,plotmap);
   set(gca,'YDir','Normal');
   axis image;




%__________________________________________________________________________
%
%                   Additional graphics functions
%__________________________________________________________________________

% Function for storing figures to file
% figHanle  Figure handle (Ex: figure(1))
% format = 1 -> bmp (24 bit)
% format = 2 -> png
% format = 3 -> eps
% format = 4 -> jpg
% format = 5 -> ill (Adobe Illustrator)
% format = 6 -> tiff (24 bit)
% figFile   Name (full path) for the file
% dpi       DPI setting for the image file
function imageStore(figHandle,format,figFile,dpi)

% Make the background of the figure white
set(figHandle,'color',[1 1 1]);
axis off
axis image
dpi = sprintf('%s%u','-r',dpi);

switch format
    case 1
        % Store the image as bmp (24 bit)
        figFile = strcat(figFile,'.bmp');
        print(figHandle, dpi, '-dbmp',figFile);
    case 2
        % Store image as png
        figFile = strcat(figFile,'.png');
        print(figHandle, dpi,'-dpng',figFile);
    case 3
        % Store image as eps (Vector format)
        figFile = strcat(figFile,'.eps');
        print(figHandle, dpi,'-depsc',figFile);
    case 4
        % Store image as jpg
        figFile = strcat(figFile,'.jpg');
        print(figHandle,dpi, '-djpeg',figFile);
    case 5
        % Store image as ai (Adobe Illustrator)
        figFile = strcat(figFile,'.ai');
        print(figHandle,dpi, '-dill',figFile);
    case 6
        % Store image as tiff (24 bit)
        figFile = strcat(figFile,'.tif');
        print(figHandle,dpi, '-dtiff',figFile);
end

function drawfield(map,axis,cmap,maxrate,binWidth,smoothing)
maxrate = ceil(maxrate);
if maxrate < 1
    maxrate = 1;
end    
n = size(map,1);
plotmap = ones(n,n,3);
for jj = 1:n
   for ii = 1:n
      if isnan(map(jj,ii))
         plotmap(jj,ii,1) = 1;
         plotmap(jj,ii,2) = 1;
		 plotmap(jj,ii,3) = 1;
      else
         rgb = pixelcolour(map(jj,ii),maxrate,cmap);
         plotmap(jj,ii,1) = rgb(1);
         plotmap(jj,ii,2) = rgb(2);
		 plotmap(jj,ii,3) = rgb(3);
      end   
   end
end   
image(axis,axis,plotmap);
set(gca,'YDir','Normal');
s = sprintf('%s%u%s%2.1f%s%3.1f','Peak ',maxrate,' Hz. BinWidth ',binWidth,'. Smoothing ',smoothing);
title(s);

function adjustaxis(minx, maxx, miny, maxy)
axis equal;
axis([minx maxx miny maxy]);


function rgb = pixelcolour(map,maxrate,cmap)
cmap1 = ...
    [    0         0    0.5625; ...
         0         0    0.6875; ...
         0         0    0.8125; ...
         0         0    0.9375; ...
         0    0.0625    1.0000; ...
         0    0.1875    1.0000; ...
         0    0.3125    1.0000; ...
         0    0.4375    1.0000; ...
         0    0.5625    1.0000; ...
         0    0.6875    1.0000; ...
         0    0.8125    1.0000; ...
         0    0.9375    1.0000; ...
    0.0625    1.0000    1.0000; ...
    0.1875    1.0000    0.8750; ...
    0.3125    1.0000    0.7500; ...
    0.4375    1.0000    0.6250; ...
    0.5625    1.0000    0.5000; ...
    0.6875    1.0000    0.3750; ...
    0.8125    1.0000    0.2500; ...
    0.9375    1.0000    0.1250; ...
    1.0000    1.0000         0; ...
    1.0000    0.8750         0; ...
    1.0000    0.7500         0; ...
    1.0000    0.6250         0; ...
    1.0000    0.5000         0; ...
    1.0000    0.3750         0; ...
    1.0000    0.2500         0; ...
    1.0000    0.1250         0; ...
    1.0000         0         0; ...
    0.8750         0         0; ...
    0.7500         0         0; ...
    0.6250         0         0 ];

cmap2 = ...
   [0.0417         0         0; ...
    0.1250         0         0; ...
    0.2083         0         0; ...
    0.2917         0         0; ...
    0.3750         0         0; ...
    0.4583         0         0; ...
    0.5417         0         0; ...
    0.6250         0         0; ...
    0.7083         0         0; ...
    0.7917         0         0; ...
    0.8750         0         0; ...
    0.9583         0         0; ...
    1.0000    0.0417         0; ...
    1.0000    0.1250         0; ...
    1.0000    0.2083         0; ...
    1.0000    0.2917         0; ...
    1.0000    0.3750         0; ...
    1.0000    0.4583         0; ...
    1.0000    0.5417         0; ...
    1.0000    0.6250         0; ...
    1.0000    0.7083         0; ...
    1.0000    0.7917         0; ...
    1.0000    0.8750         0; ...
    1.0000    0.9583         0; ...
    1.0000    1.0000    0.0625; ...
    1.0000    1.0000    0.1875; ...
    1.0000    1.0000    0.3125; ...
    1.0000    1.0000    0.4375; ...
    1.0000    1.0000    0.5625; ...
    1.0000    1.0000    0.6875; ...
    1.0000    1.0000    0.8125; ...
    1.0000    1.0000    0.9375];
if strcmp(cmap,'jet')
   steps = (31*(map/maxrate))+1;
   steps = round(steps);
   if steps>32; steps = 32; end
   if steps<1; steps = 1; end
   rgb = cmap1(steps,:);
else
   steps = (31*(map/maxrate))+1;
   steps = round(steps);
   if steps>32; steps = 32; end
   if steps<1; steps = 1; end
   rgb = cmap2(steps,:);
end    
