[VT1_TimeStamps,x,y,VT1_Targets,VT1_Header] = Nlx2MatVT('VT1.nvt',[1 1 1 0 1 0],1,1);
x(x==0)=NaN;
y(y==0)=NaN;
x=x/6;
y=y/6;
plot(x(~isnan(x)),y(~isnan(y)));

[vel, vel_timestamps, path]=velocity(x,y,VT1_TimeStamps,6,6);
vel=smooth(vel);

immobile_ind=find(vel<5);
%immobile_Times=vel(immobile_ind);

xs=x';
xs(vel>5)=NaN;
ys=y';
ys(vel>5)=NaN;
plot(xs,ys,'r')
ts=VT1_TimeStamps';
ts(vel>5)=NaN;

x_immobile=x(immobile_ind);
y_immobile=y(immobile_ind);
t_immobile=VT1_TimeStamps(immobile_ind);

time_immobile=length(x_immobile)/length(x);
save('time_immobile', 'time_immobile')

%clearvars -except time_immobile t_immobile x_immobile y_immobile