positions_mac('AxInfo.txt',0)

split_1minbins
dir='TT6unit6';
cd(dir)
post_splits
%spksperMin_plots

load spks.mat

fullSplit(sess,session,tetrode,unit,Tetrodecell,posx,posy,post,spkx,spky,ts,mapAxis,p,visited)
clearvars -except dir

AllHeatMaps
disp('done')
close all