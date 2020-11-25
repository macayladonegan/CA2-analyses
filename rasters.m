load spks.mat
ImportEvents
t=ts';

figure(1) 
clf 

subplot(2,1,1)
plot([t;t],[ones(size(t));zeros(size(t))],'r-')
axis([0 max(t)+1 -1 2])

mkdir('rasters');
cd('rasters')

%close all

A=Events_TimeStamps';

for k=2:length(A)
A(k)=A(k)-Events_TimeStamps(2);
end

subplot(2,1,2)
plot([A;A],[ones(size(A));zeros(size(A))],'b-')
axis([0 max(A)+1 -1 2])


Tetrode=num2str(tetrode);
Tetrode=strcat('TT',Tetrode);
Unit=num2str(unit);
Unit=strcat('unit',Unit);
Tetrodecell=strcat(Tetrode,Unit);
filename=strcat(Tetrodecell, 'rasterPlot.tif');
saveas (figure(1),filename)


cd ..
%clear