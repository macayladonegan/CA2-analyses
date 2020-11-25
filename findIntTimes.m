
function[leftCup, rightCup]=findIntTimes_behavior(lxc,lyc,rxc,ryc,posx,posy,post)

close all

%now find area around cup
%plot first to confirm
%[x_zone,y_zone]=pol2cart([1:360],(ones(1,360)*10));
%plot(x_zone+lxc,y_zone+lyc,'yo')

%find poses in interaction zone
posdata={posx posy};
rad=12; %%wanna change the definition of the interaction zone
hk=[lxc lyc];
[pos_points,in] = pointsincircle(posdata,rad,hk);
posx_L=pos_points.in{1,1};
posy_L=pos_points.in{1,2};
post_L=post(in);

%check plot
figure(1)
plot(posx,posy,'color',[0.5,0.5,0.5]')
hold on
plot(posx_L,posy_L,'k','linewidth',2)
axis([-40 40 -25 25]);

%find spks in interaction zone (tailor for each session)
spkdata={spkx spky};
[spk_points,in] = pointsincircle(spkdata,rad,hk);
spkx_inL=spk_points.in{1,1};
spky_inL=spk_points.in{1,2};
spkx_outL=spk_points.out{1,1};
spky_outL=spk_points.out{1,2};
plot(spkx_inL,spky_inL, '.r')
numSpksInL=length(spkx_inL);
numSpksOutL=length(spkx_outL);
ts_L=ts(in);
leftCup={spkx_inL spky_inL ts_L post_L posx_L posy_L numSpksInL numSpksOutL};


savefig(figure(1), 'Int_Zones')

%close all








