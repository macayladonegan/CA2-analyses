
 tetrodes=[1,12,23,27,31,30,29,28,32,2,3,4,5,6,7,8,9,10,11,13,14,15,16,17,18,19,20,21,22,24,25,26];%tetrode order
 rawLFP(UN.startUN:UN.endUN,:)=0;
 plot(rawLFP(:,32)) 
   for  bb=[1,8]
        TTname=num2str(bb);
        thisDir=strcat('Binaries',TTname);mkdir(thisDir); 
        
        
        parfor gg=1:length(tetrodes)
            thisLFP=strcat('101_CH',num2str(tetrodes(gg)),'.continuous');
            [rawLFP(:,gg),~,~]= load_open_ephys_data_faster(thisLFP);
        end
        
        
        cd(thisDir)
        make_ChannelMap(pwd)
        
        fid = fopen('DATA.dat', 'w');
        fwrite(fid, rawLFP','int16');
        fclose(fid);
        
        
        useGPU = 1; % do you have a GPU? Kilosorting 1000sec of 32chan simulated data takes 55 seconds on gtx 1080 + M2 SSD.
        applyCARtoDat(strcat(pwd,'\DATA.dat'), 4);

        fpath    = pwd; % where on disk do you want the simulation? ideally and SSD...
        if ~exist(fpath, 'dir'); mkdir(fpath); end
        addpath(genpath('C:\Users\macayla\Desktop\programming\KiloSort-master\')) % path to kilosort folder
        addpath(genpath('C:\Users\macayla\Desktop\programming\npy-matlab-master')) % path to npy-matlab scripts
        pathToYourConfigFile = 'C:\Users\macayla\Desktop\programming\'; % for this example it's ok to leave this path inside the repo, but for your own config file you *must* put it somewhere else!
        run(fullfile(pathToYourConfigFile,'kilosortConfigCAR.m'))
         
        [rez, DATA, uproj] = preprocessData(ops); % preprocess data and extract spikes for initialization
        rez = fitTemplates(rez, DATA, uproj);  % fit templates iteratively
        
        rez = fullMPMU(rez, DATA);% extract final spike times (overlapping extraction)

        rezToPhy(rez, fpath);
        
        clear rawLFP 
        clear memory
        cd ..
        
   end