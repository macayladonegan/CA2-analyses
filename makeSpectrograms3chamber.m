%function makeSpectrograms3chamber=(timewin,fpass,lfp)

%%params
timebandwidth=2;
params.tapers=[timebandwidth timebandwidth*2-1];%alex uses 2 3
params.pad=2;
params.Fs=2000;
params.fpass=fpass;
params.err=[1 2];
params.trialave=0;

figure()
subplot(1,5,1)
movingwin=[.5 .05];
[hab_spectrogram,t,f]=mtspecgramc(hab_lfp(:,1),movingwin,params);
log_hab_spectrogram=log(hab_spectrogram);
plot_matrix(log_hab_spectrogram,t,f);
xlabel([]); % plot spectrogram
caxis([6 13]); colorbar;
colormap(jet)

subplot(1,5,2)
[cup_spectrogram,t,f]=mtspecgramc(cup_lfp(:,1),movingwin,params);
log_cup_spectrogram=log(cup_spectrogram);
plot_matrix(log_cup_spectrogram,t,f);
xlabel([]); % plot spectrogram
caxis([6 13]); colorbar;
colormap(jet)

subplot(1,5,3)
[fam1_spectrogram,t,f]=mtspecgramc(fam1_lfp(:,1),movingwin,params);
log_fam1_spectrogram=log(fam1_spectrogram);
plot_matrix(log_fam1_spectrogram,t,f);
xlabel([]); % plot spectrogram
caxis([6 13]); colorbar;
colormap(jet)

subplot(1,5,4)
[nov_spectrogram,t,f]=mtspecgramc(nov_lfp(:,1),movingwin,params);
log_nov_spectrogram=log(nov_spectrogram);
plot_matrix(log_nov_spectrogram,t,f);
xlabel([]); % plot spectrogram
caxis([6 13]); colorbar;
colormap(jet)

subplot(1,5,5)
[fam2_spectrogram,t,f]=mtspecgramc(fam2_lfp(:,1),movingwin,params);
log_fam2_spectrogram=log(fam2_spectrogram);
plot_matrix(log_fam2_spectrogram,t,f);
xlabel([]); % plot spectrogram
caxis([6 13]); colorbar;
colormap(jet)

%end