function [pos_all,spike_all,time,numSpikes,spikeRates]=splitChambers(posx,posy,post,spkx,spky,thisSession)

%initialize variables for positions
m=range(posx)/3;
n=min(posx);
p=max(posx);

%define pos for chambers
rightchamb_posx=find (posx<(n+m));
centchamb_posx=find ((posx>(n+m))& (posx<p-m));
leftchamb_posx=find(posx>(p-m));

%redefine posx,y, and t for each chamber
right_posx=posx(rightchamb_posx);
right_posy=posy(rightchamb_posx);
right_post=post(rightchamb_posx);

center_posx=posx(centchamb_posx);
center_posy=posy(centchamb_posx);
center_post=post(centchamb_posx);

left_posx=posx(leftchamb_posx);
left_posy=posy(leftchamb_posx);
left_post=post(leftchamb_posx);

% figure(3)
% plot(right_posx,right_posy);hold on;plot(center_posx,center_posy,'g');hold on; plot(left_posx,left_posy,'r')
% saveas(figure(3),strcat(thisSession,'velPlot'))
% close

%initialize variables for spk data
rightchamb_spkx=find (spkx<(n+m));
centchamb_spkx=find ((spkx>(n+m))&(spkx<(p-m)));
leftchamb_spkx=find(spkx>(p-m));

%redefine spks for each chamber
right_spkx=spkx(rightchamb_spkx);
right_spky=spky(rightchamb_spkx);
%right_ts=ts(rightchamb_spkx);

center_spkx=spkx(centchamb_spkx);
center_spky=spky(centchamb_spkx);
%center_ts=ts(centchamb_spkx);

left_spkx=spkx(leftchamb_spkx);
left_spky=spky(leftchamb_spkx);
%left_ts=ts(leftchamb_spkx);

%calculate number of spikes in each chamber
numSpikes_right=length(right_spkx);
numSpikes_center=length(center_spkx);
numSpikes_left=length(left_spkx);
numSpikes_total=length(spkx);

%calculate time spent in each chamber
time_right=length(right_post);
time_center=length(center_post);
time_left=length(left_post);
time_total=length(post);

%calculate spike rates
spikeRates_right=numSpikes_right/time_right;
spikeRates_center=numSpikes_center/time_center;
spikeRates_left=numSpikes_left/time_left;
spikeRates_total=numSpikes_total/time_total;

pos_all=padcat(right_posx, right_posy, right_post,center_posx, center_posy, center_post,left_posx, left_posy, left_post);
spike_all=padcat(right_spkx, right_spky, center_spkx, center_spky, left_spkx, left_spky);
%xlswrite('pos_all.xlsx',pos_all)


numSpikes={numSpikes_right numSpikes_center numSpikes_left numSpikes_total};
numSpikes=cell2mat(numSpikes);
%numSpikesfilename=strcat(tetrode,unit,'numSpikes.xlsx');
%xlswrite(numSpikesfilename,numSpikes)

time= {time_right time_center time_left time_total};
time=cell2mat(time);
%timefilename=strcat(tetrode,unit,'time.xlsx');
%xlswrite(timefilename, time)

spikeRates= {spikeRates_right spikeRates_center spikeRates_left spikeRates_total};
spikeRates=cell2mat(spikeRates);
%spikeRatesfilename=strcat(tetrode,unit,'spikeRates.xlsx');
%xlswrite(spikeRatesfilename,spikeRates)





























