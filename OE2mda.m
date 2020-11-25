
tic
LFPS=ls('*CH*.continuous');
for aa=1:length(LFPS)
    thisLFP=LFPS(aa,:);
    thisLFP=strtrim(thisLFP);
    [LFPdata(:,aa), LFPtimestamps, LFPinfo]=load_open_ephys_data_faster(thisLFP);
end
save('LFPdata','LFPdata','-v7.3'); save ('LFPtimestamps','LFPtimestamps')

for bb=1:length(LFPS)
    figure(bb)
    plot(LFPdata(1:2000,bb))
end

  

%%split into mda files for each tetrode
%%for 8 tts with 4 channels-initialize params
numTTs=8; numChannels=4;

mkdir('MDAs');cd('MDAs')
for bb=1:numTTs
    LFPs=R.LFPs;
    thisLFP=LFPs(4*bb-3:4*bb,:);
    thisLFP=int32(thisLFP);
    TTname=num2str(bb);
    thisdir=strcat('MDA',TTname);mkdir(thisdir);cd(thisdir)
    mdaname=strcat('raw','.mda');
    writemda(thisLFP,mdaname,'float32')
    
    %% add geom file to each folder
    g=[0,0
        -25,25
        25,25
        0,50];
    csvwrite('geom.csv',g)
    %% copy param files into each folder
    thisdir=pwd;
    copyfile C:\Users\macayla\Documents\GitHub\mountainsort_examples\examples\example1_mlp\params.json params.json
    copyfile C:\Users\macayla\Documents\GitHub\mountainsort_examples\examples\example1_mlp\mountainsort3.mlp mountainsort3.mlp
    cd ..
end
cd ..

toc