clearvars
DATA=fopen('DATA.dat');
DATA=fread(DATA');


applyCARtoDat(strcat(pwd,'\DATA.dat'), 4);
useGPU = 1;
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
        
cd ..
clear memory

g=gpuDevice(1);
reset(g)