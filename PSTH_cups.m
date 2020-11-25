
%cd(dir)
load spks.mat
cd('novel')
load('leftCup.mat')
load('rightCup.mat')

    xc=-23;
    yc=-3;
left_posx=leftCup{5};
left_posy=leftCup{6};
[x_polL,y_polL]=cart2pol(left_posx-xc, left_posy-yc);
polarplot(x_polL,y_polL,'k')
hold on

left_spkx=leftCup{1};
left_spky=leftCup{2};
[spkx_polL,spky_polL]=cart2pol(left_spkx-xc, left_spky-yc);
polarplot(spkx_polL,spky_polL,'.r')

%close all

inTargetind=zeros(1,length(y_polL));
for ii=1:(length(x_polL))-1
    inTargetind(ii)=diff(y_polL(ii),y_polL(ii+1));
end

inTargetind=inTargetind';
inTarget=find(inTargetind==1);
outTarget=find(inTargetind==0);
inTarget_x=x_polL(inTarget);
inTarget_y=y_polL(inTarget);

%now take these and split continuous segments of moving toward the cup into
%trials
splitTrial=zeros(1,length(inTargetind));
for jj=1:(length(inTargetind))-1
    splitTrial(jj)=ne(inTargetind(jj),inTargetind(jj+1));
end
splitTrial=splitTrial';

TurnAround=(zeros(1,length(splitTrial)))';
for kk=2:(length(inTargetind))
    TurnAround(kk)=ne(splitTrial(kk),0) & ne(inTargetind(kk-1),0);
end

TurnAround_ind=find(TurnAround==1);
post_L=leftCup{4};
TurnAround_Times=post_L(TurnAround_ind);
ts_l=leftCup{3};
 
trial=zeros(1,length(TurnAround_Times));
ts=zeros(1,length(TurnAround_Times));
for ll=1:length(TurnAround_Times)
    trial(ll)=TurnAround_Times(ll);
    ts
    psth(ts_L,10,1000,)
end
