% Generate data

load('spks.mat')
cd ..
ImportEvents
Events_TimeStamps=Events_TimeStamps';
Events_TimeStamps=Events_TimeStamps';
Events_TimeStamps=Events_TimeStamps-Events_TimeStamps(1);
even = Events_TimeStamps(2:2:length(Events_TimeStamps));
odd = Events_TimeStamps(1:2:length(Events_TimeStamps));
ts=ts-post(1);
%load spks.mat
t=ts';
o=Events_TimeStamps;

cd(Tetrodecell)

figure(1) 
clf 

subplot(1,1,1)
plot([t;t],[ones(size(t));zeros(size(t))],'g')
axis([0 max(t)+1 -2 2])
hold on
plot([o;o],[-(ones(size(o)));zeros(size(o))],'b')
axis([0 max(o)-1 -2 2])

mkdir('rasters');
cd('rasters')

Tetrode=num2str(tetrode);
Tetrode=strcat('TT',Tetrode);
Unit=num2str(unit);
Unit=strcat('unit',Unit);
Tetrodecell=strcat(Tetrode,Unit);
filename=strcat(Tetrodecell, 'rasterPlot.tif');
saveas (figure(1),filename)

cd ..
cd ..
clear
%close all