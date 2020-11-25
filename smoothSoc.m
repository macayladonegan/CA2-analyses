ss=1;
animalIDs=ls('*3chamber*');
sessions={'hab', 'cups', 'fam1', 'nov','fam2'};
yy=size(animalIDs);


for kk=1:yy(1)
    cd(animalIDs(kk,1:end))
makeEvsMatrix_ss

load('R')
timeStamps=cell2mat(R.TimeStamps)';
pos_ss=R.Pos.t(1:ss:end);

    for r=1:length(timeStamps)
        q= pos_ss;
        val(r) = timeStamps(r); %value to find
        
    end
    
    closest_ind=ones(1,length(timeStamps));
    for aa=1:length(timeStamps)
        tmp = abs(q-val(aa));
        [idx idx]= min(tmp); %index of closest value
        closest_ind(aa)=idx;
    end
    
numSess=5;
Start=ones(1,5);End=ones(1,5);
for aa=1:numSess
    Start(aa)=closest_ind(2*aa-1);
    End(aa)=closest_ind(2*aa);
end

Labels=zeros(1,length(pos_ss));
    for aa=1:numSess
        Labels(Start(aa):End(aa))=aa;
    end
    
    clearvars -except Labels evs_matrix_ss ss kk yy animalIDs Firing FiringZ
    
    
    %%don't subsample this one, it makes it harder to index.
% clearvars
% makeEvsMatrix

load('R.mat');load('cups.mat');

posdata={R.Pos.x1(1:ss:end) R.Pos.y1(1:ss:end)};
rad=15;
hk=[cups.rxc cups.ryc];
[~,Int_indsL] = pointsincircle(posdata,rad,hk);    

%load('evs_matrix.mat')
evsmatrixLInt=evs_matrix_ss(:,Int_indsL);LabelsL=Labels(:,Int_indsL);


%%number of bins you want for visualization- maybe 10?
sizeEvs=size(evsmatrixLInt);
numBins=50;
for hh=1:sizeEvs(1)
    for gg=1:max(LabelsL)
        binsize= floor(length(find(LabelsL==gg))/numBins);
        thisFiring=evsmatrixLInt(hh,LabelsL==gg);
        firing(hh,(numBins*gg-(numBins-1):numBins*gg))=sum(reshape(thisFiring(1:numBins*binsize),binsize,numBins));
    end
end

Firing{kk}=firing;
FiringZ{kk}=zscore_nan(firing')';



clear evs* firing
cd ..
end
%% 
FR_all=vertcat(Firing{:});
hab_means=mean(FR_all(:,1:50)');
cups_means=mean(FR_all(:,51:100)');
fam1_means=mean(FR_all(:,101:150)');
nov_means=mean(FR_all(:,151:200)');
fam2_means=mean(FR_all(:,201:250)');
%% 
for kk=1:yy(1)
    figure(kk);heatmap(FiringZ{1,kk});grid off;colormap viridis;caxis([-1 1])
end
%% 
for kk=1:yy(1)-1
    for ii=1:length(FiringZ{1,kk})
       sz=size(FiringZ{1,kk});
       normFR(:,kk)=sum(FiringZ{1,kk})/sz(1);
       %figure(kk)
       thisSTD(:,kk)=movstd(normFR(:,kk),3);
       %plot(filterGauss(normFR(:,kk),3))
       %color(kk)=rand(1,3);
       shadedErrorBar(1:length(normFR),filterGauss(normFR(:,kk),3),thisSTD(:,kk),'lineprops',{'k','markerfacecolor',[rand(1,3)]})
       hold on
    end
end
%% 
for kk=1:yy(1)-1
      color(:,kk)=[rand(1,3)];
      shadedErrorBar(1:length(normFR),filterGauss(normFR(:,kk),3),thisSTD(:,kk),'lineprops',{color(kk),'markerfacecolor',color(kk)})
end
%% 
shadedErrorBar(1:length(normFR),filterGauss(normFR(:,1),3),thisSTD(:,1),'lineprops','g')
hold on
shadedErrorBar(1:length(normFR),filterGauss(normFR(:,2),3),thisSTD(:,2),'lineprops','c')
shadedErrorBar(1:length(normFR),filterGauss(normFR(:,3),3),thisSTD(:,3),'lineprops','r')
shadedErrorBar(1:length(normFR),filterGauss(normFR(:,4),3),thisSTD(:,4),'lineprops','b')
shadedErrorBar(1:length(normFR),filterGauss(normFR(:,5),3),thisSTD(:,5),'lineprops','y')
shadedErrorBar(1:length(normFR),filterGauss(normFR(:,6),3),thisSTD(:,6),'lineprops','m')
%% norm FR boxplots

m(:,1)=nanmean(normFR(1:50,1:6));
m(:,2)=nanmean(normFR(51:100,1:6));
m(:,3)=nanmean(normFR(101:150,1:6));
m(:,4)=nanmean(normFR(151:200,1:6));
m(:,5)=nanmean(normFR(201:250,1:6));

boxplot(m)

%% 

Firing=vertcat(Firing{:});
SocFiring=Firing(:,101:250);
SocFiringZ=zscore_nan(SocFiring')';

%% order by highest novel firing
for ii=1:length(hab_means)
order_vector(ii)=sum(SocFiringZ(ii,51:100));
end
SocFiringZ=horzcat(order_vector',SocFiringZ);

for ii=1:length(hab_means)
SocFiring_smooth1(ii,1:50)=filterGauss(SocFiringZ(ii,2:51),std(SocFiringZ(ii,2:51));
end

for ii=1:length(hab_means)
SocFiring_smooth2(ii,1:50)=filterGauss(SocFiringZ(ii,52:101),5);
end

for ii=1:length(hab_means)
SocFiring_smooth3(ii,1:50)=filterGauss(SocFiringZ(ii,102:151),5);
end
%% 
diff_real=mean(SocFiringZ(:,51:100)')-mean(SocFiringZ(:,1:50)');

for jj=1:1000 % number of shuffles
    SocFiring_sh=SocFiring(:,randperm(size(SocFiring,2)));
    SocFiringZ_sh=zscore(SocFiring_sh')';
    diff_sh(jj,:)=mean(SocFiringZ_sh(:,51:100)')-mean(SocFiringZ_sh(:,1:50)');
end

    this_mean=mean(diff_sh);
    this_std=std(diff_sh);
    conf_95=this_mean+2*this_std;
    is_nov_mod=diff_real>conf_95;

    num_mod=sum(is_nov_mod)/length(is_nov_mod);
    %% 
    
    diff_real=mean(SocFiringZ(:,101:150)')-mean(SocFiringZ(:,1:50)');

for jj=1:1000 % number of shuffles
    SocFiring_sh=SocFiring(:,randperm(size(SocFiring,2)));
    SocFiringZ_sh=zscore(SocFiring_sh')';
    diff_sh(jj,:)=mean(SocFiringZ_sh(:,51:100)')-mean(SocFiringZ_sh(:,1:50)');
end

    this_mean=mean(diff_sh);
    this_std=std(diff_sh);
    conf_95=this_mean+3*this_std;
    is_nov_mod=diff_real>conf_95;

    num_mod_fam=sum(is_nov_mod)/length(is_nov_mod);


