%% TimeSTART
% go to vid file and find frame where barriers out
barrierIn=610;
barrierOut=821;%%in seconds
lengthVid=1434;%% in seconds
sampRate=length(x)/lengthVid;%%calculate because it seems like we're losing frames

Frame_barrierOut=barrierOut*sampRate;
Frame_barrierIn=barrierIn*sampRate;
%% 

trajFile=ls('*trajectories.mat');
load(trajFile)

x=trajectories(:,:,1);
y=trajectories(:,:,2);
t=(1:length(x))';


scale_x=range(x)/65;
x=x/scale_x;

scale_y=range(y)/41;
y=y/scale_y;
centre = centreBox(x,y);
x = x - centre(1);
y = y - centre(2);
    


%% 
disp(pwd)
novLocation=input('Where is novel mouse? 1=left 2=right');
%% split into hab and soc
hab_x=x(1:Frame_barrierIn,1);
hab_y=y(1:Frame_barrierIn,1);
hab_t=t(1:Frame_barrierIn,1);

soc_x=x(Frame_barrierOut:end,1);
soc_y=y(Frame_barrierOut:end,1);
soc_t=t(Frame_barrierOut:end,1);

%% compute time in each chamber


m=range(hab_x)/3;
n=min(hab_x);
p=max(hab_x);

bottom_ind=find (hab_x<(n+m));
cent_ind=find ((hab_x>(n+m))& (hab_x<p-m));
top_ind=find(hab_x>(p-m));

hab_time(1,:)=length(hab_t(bottom_ind));
hab_time(2,:)=length(hab_t(cent_ind));
hab_time(3,:)=length(hab_t(top_ind));

figure()
bar(hab_time); title('habituation')
%% 

m1=range(soc_x)/3;
n1=min(soc_x);
p1=max(soc_x);

bottom_ind=find (soc_x<(n+m));
cent_ind=find ((soc_x>(n+m))& (soc_x<p-m));
top_ind=find(soc_x>(p-m));

soc_time(1,:)=length(soc_t(bottom_ind));
soc_time(2,:)=length(soc_t(cent_ind));
soc_time(3,:)=length(soc_t(top_ind));

figure()
bar(soc_time); title('3 chamber')


%% 


if novLocation==1
    timeNov=soc_time(1);
    timeFam=soc_time(3);
else
    timeNov=soc_time(3);
    timeFam=soc_time(1);
end
%% Interaction

[cups.lxc,cups.lyc]=findcup(x,y)
close all
[cups.rxc,cups.ryc]=findcup(x,y)

save('cups','cups')
%% 

[postL,postR]=findIntTimes_behavior(cups.lxc,cups.lyc,cups.rxc,cups.ryc,soc_x,soc_y,soc_t);



