thisSheet=ls('*.xlsx');
Behavior=readtable(thisSheet);
Behavior.Properties.VariableNames{2} = 'START';
Behavior.Properties.VariableNames{3} = 'END';

ReadVidTimeStamps
fps=15; %%frames per second

lightOn_inds=find(meanGrayLevels>mean(meanGrayLevels)+2*std(meanGrayLevels))/fps;

%%load Events
[Events.Ids, Events.timestamps, ~]=load_open_ephys_data_faster('all_channels.events');
[~, LFPtimestamps, ~]=load_open_ephys_data('101_CH1.continuous');
sampRate=30000;
Events.timestamps=Events.timestamps-LFPtimestamps(1);
save('Events','Events')

Behavior.START=Behavior.START(:)-lightOn_inds(1);
Behavior.END=Behavior.END(:)-lightOn_inds(1);
save('Behavior.mat','Behavior')

Behavior.behavior=string(Behavior.behavior);
save('Behavior','Behavior')
nothing_inds=Behavior.behavior=="nothing";
explore_inds=Behavior.behavior=="SE";
dom_inds=Behavior.behavior=="SD";
aggress_inds=Behavior.behavior=="SA";
