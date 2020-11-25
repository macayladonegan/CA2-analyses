[VT1_TimeStamps,x,y,VT1_Targets,VT1_Header] = Nlx2MatVT('VT1.nvt',[1 1 1 0 1 0],1,1);
x1=x';x1(x1==0)=[];x1=smooth(x1);
y1=y';y1(y1==0)=[];y1=smooth(y1);
inds=find(x>0);
t=VT1_TimeStamps';t=t(inds);
qq=t(1);
for uu=1:length(t)
    t(uu)=t(uu)-qq;
end
t=t/1e+06;

[vel, vel_timestamps, path]=velocity(x,y,VT1_TimeStamps);
vel=smooth(vel);
%[x,y,t] = remBadTrack(x,y,VT1_TimeStamps,100/2000);

[spkx,spky,newTs] = spikePos(ts,x1,y1,t,t);

figure(1)
plot(x1,y1,'k')
hold on


immobile_ind=find(vel<5);
%immobile_Times=vel(immobile_ind);

xs=x';
xs(vel>5)=NaN;
ys=y';
ys(vel>5)=NaN;
plot(xs,ys,'r')
ts=VT1_TimeStamps';
ts(vel>5)=NaN;
hold off

x_immobile=x(immobile_ind);
y_immobile=y(immobile_ind);
t_immobile=VT1_TimeStamps(immobile_ind);

time_immobile=length(x_immobile)/length(x);

ImportCSC_mac
%ImportEvents

%bandpass CSCs5-8 for 150-300 Hz
%normalize frequencies
lowcut=(100*2/2000);
highcut=(250*2/2000);
d=fdesign.bandpass('N,F3dB1,F3dB2',10,lowcut,highcut,5e2);
Hd = design(d,'butter');

%visualize filt
%fvtool(Hd)

%straightenCSCs-HPC (channels 5-8) you may have to change this animal to
%animal
[vHPC_Samples,vHPC_TimeStamps]=straightenCSC(CSC3_Samples,CSC3_TimeStamps);
[CA2_Samples,CA2_TimeStamps]=straightenCSC(CSC4_Samples,CSC4_TimeStamps);
%[nAC_Samples,nAC_TimeStamps]=straightenCSC(CSC3_Samples,CSC3_TimeStamps);
[mPFC_Samples,mPFC_TimeStamps]=straightenCSC(CSC4_Samples,CSC4_TimeStamps);
[CSC5_Samples,CSC5_TimeStamps]=straightenCSC(CSC5_Samples,CSC5_TimeStamps);
[CSC6_Samples,CSC6_TimeStamps]=straightenCSC(CSC6_Samples,CSC6_TimeStamps);
[CSC7_Samples,CSC7_TimeStamps]=straightenCSC(CSC7_Samples,CSC7_TimeStamps);
[CSC8_Samples,CSC8_TimeStamps]=straightenCSC(CSC8_Samples,CSC8_TimeStamps);

%filter samples
vHPC_Samples_filt=filter(Hd,vHPC_Samples);
CA2_Samples_filt=filter(Hd,CA2_Samples);
%nAC_Samples_filt=filter(Hd,nAC_Samples);
mPFC_Samples_filt=filter(Hd,mPFC_Samples);
CSC5_Samples_filt=filter(Hd,CSC5_Samples);
CSC6_Samples_filt=filter(Hd,CSC6_Samples);
CSC7_Samples_filt=filter(Hd,CSC7_Samples);
CSC8_Samples_filt=filter(Hd,CSC8_Samples);

% pos data stuff- velocity, etc


figure(1)
subplot(5,1,1)
plot(vHPC_TimeStamps,vHPC_Samples_filt,'r')
subplot(5,1,2)
plot(CA2_TimeStamps,CA2_Samples_filt,'m')
%subplot(8,1,3)
%plot(nAC_TimeStamps,nAC_Samples_filt, 'c')
subplot(5,1,3)
plot(mPFC_TimeStamps,mPFC_Samples_filt, 'g')
subplot(5,1,4)
plot(CSC5_TimeStamps,CSC5_Samples_filt, 'b')
subplot(5,1,5)
plot(CSC6_TimeStamps,CSC6_Samples_filt,'b')
% subplot(8,1,7)
% plot(CSC7_TimeStamps,CSC7_Samples_filt,'b')
% subplot(8,1,8)
% plot(CSC8_TimeStamps,CSC8_Samples_filt,'b')

saveas(figure(1),'filteredLFPs')


%The literature uses a variety of values for defining SWRs, between 3-7
%STDs
%dCA1 SWR
CSC5_SWR_ind=find(abs(CSC5_Samples_filt)>3*std(CSC5_Samples_filt));
CSC5=CSC5_Samples_filt;
CSC5(abs(CSC5)<(3*std(CSC5_Samples_filt)))=NaN;
figure(2)
plot(CSC5_TimeStamps,CSC5_Samples_filt,'b')
hold on
plot(CSC5_TimeStamps,CSC5,'g')
axis([min(CSC5_TimeStamps) max(CSC5_TimeStamps) -6000 6000])
saveas(figure(2),'dCA1_swrs')
hold off

%dCA2 SWRs
CSC4_SWR_ind=find(abs(CA2_Samples_filt)>3*std(CA2_Samples_filt));
CSC4=CA2_Samples_filt;
CSC4(abs(CSC4)<(3*std(CA2_Samples_filt)))=NaN;
figure(3)
plot(CA2_TimeStamps,CA2_Samples_filt,'b')
hold on
plot(CA2_TimeStamps,CSC4,'g')
saveas(figure(3),'dCA2_swrs')
hold off

%find ts where vel < 3 cm/s


%Break down CSCs into immoblie.  Use parcel
[CSC6_ref_by_speed,CSC6_ref_by_speed_ts] = Parcel(CSC6_Samples_filt, CSC6_TimeStamps, vel, vel_timestamps, [5,30], 200);
immobile=ismember(CSC6_TimeStamps,CSC6_ref_by_speed_ts{1});

hold off

% axis([ 0 length(CSC6_TimeStamps)-1 2])
% plot(CSC6_TimeStamps,immobile,'-m')

clear
close all

