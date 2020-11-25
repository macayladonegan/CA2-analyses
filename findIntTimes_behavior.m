
function[post_L, post_R]=findIntTimes_behavior(lxc,lyc,rxc,ryc,posx,posy,post)

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

%find poses in interaction zone
posdata={posx posy};
rad=12; %%wanna change the definition of the interaction zone
hk=[rxc ryc];
[pos_points,in] = pointsincircle(posdata,rad,hk);
posx_R=pos_points.in{1,1};
posy_R=pos_points.in{1,2};
post_R=post(in);

%check plot
figure(1)
plot(posx,posy,'color',[0.5,0.5,0.5]')
hold on
plot(posx_R,posy_R,'k','linewidth',2)
axis([-40 40 -25 25]);




savefig(figure(1), 'Int_Zones')

%close all








