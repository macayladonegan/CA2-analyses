animalIDs=ls('*3chamber*');
sessions={'hab', 'cups', 'fam1', 'nov','fam2'};
yy=size(animalIDs);
ss=1; %%how much you want to subsample by- this will affect performance so be consistant, 3 is ~ 100 ms bins,also try 500 (from Anderson paper)


%%not just difference divided by standard deviation so we are taking into
%%account S/N 
for hh=1:yy(1)
    cd(animalIDs(hh,1:end))

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
    
    clearvars -except Labels evs_matrix_ss ss hh yy animalIDs DecodeInt DecodeInt_sh Perf
    
    

load('R.mat');load('cups.mat');

posdata={R.Pos.x1(1:ss:end) R.Pos.y1(1:ss:end)};
rad=12;
hk=[cups.lxc cups.lyc];
[~,Int_indsL] = pointsincircle(posdata,rad,hk);    

%load('evs_matrix.mat')
evsmatrixLInt=evs_matrix_ss(:,Int_indsL);LabelsL=Labels(:,Int_indsL);
posdata={R.Pos.x1(1:ss:end) R.Pos.y1(1:ss:end)};
rad=12;
hk=[cups.rxc cups.ryc];
[~,Int_indsR] = pointsincircle(posdata,rad,hk);    

evsmatrixRInt=evs_matrix_ss(:,Int_indsR);LabelsR=Labels(:,Int_indsR);

numChunks=5;%% numChunks is crossval
for i=3:max(Labels)
    for j=3:max(Labels)
        if i==j[NaN NaN NaN NaN NaN;
                    NaN NaN NaN NaN NaN;
                    NaN NaN NaN NaN NaN;
                    NaN NaN NaN NaN NaN;
                    NaN NaN NaN NaN NaN];
            CorrectTest{i,j}=NaN;
        else
        [~,CorrectTest{i,j},~]=DecodeInteraction(evsmatrixLInt(:,LabelsL==i),evsmatrixLInt(:,LabelsL==j),LabelsL(:,LabelsL==i),LabelsL(:,LabelsL==j),numChunks,0);
    
        end
    end    
    end
% 
% numChunks=5;%% numChunks is crossval
% for i=1:max(Labels)
%     for j=1:max(Labels)
%         [CorrectTrain{i,j},CorrectTest{i,j},Mdl{i,j}]=DecodeInteraction(evsmatrixRInt(:,LabelsR==i),evsmatrixRInt(:,LabelsR==j),LabelsR(:,LabelsR==i),LabelsR(:,LabelsR==j),numChunks,0);
%     end
% end

%CT=cell2mat(CorrectTest);CT(CT==1)=NaN;CT(CT==0)=NaN;
CT{hh}=CorrectTest;
%var1=var(CT,'omitnan'); var1=mean(var1);

% CTmeans=zeros(numChunks);
% for i=3:numChunks
%     for j=3:numChunks
%     thisSess=CorrectTest{i,j}(:,:);thisSess(thisSess==0)=NaN;   
%     CTmeans(i,j)=mean(nanmean(thisSess));
%     CTstd(i,j)=mean(nanstd(thisSess));
%     end
% end

evs_matrix=evsmatrixLInt;
evs_matrix_sh=evs_matrix(:,randperm(size(evs_matrix,2)));


%%one vs one sessions decoding
numChunks=5;%% numChunks is crossval
Labels=LabelsL;
for i=3:max(Labels)
    for j=3:max(Labels)
        if i==j
            CorrectTest{i,j}=[NaN NaN NaN NaN NaN;
                    NaN NaN NaN NaN NaN;
                    NaN NaN NaN NaN NaN;
                    NaN NaN NaN NaN NaN;
                    NaN NaN NaN NaN NaN];
        else
        [~,CorrectTest_sh{i,j},~]=DecodeInteraction(evs_matrix_sh(:,Labels==i),evs_matrix_sh(:,Labels==j),Labels(:,Labels==i),Labels(:,Labels==j),numChunks,0);
        end
    end
end

%CT_sh=cell2mat(CorrectTest_sh);CT_sh(CT_sh==0)=NaN;
CT_sh{hh}=CorrectTest_sh;

CTmeans_sh=zeros(numChunks);
for i=3:numChunks
    for j=3:numChunks
    thisSess_sh=CorrectTest_sh{i,j}(:,:);thisSess_sh(thisSess_sh==0)=NaN;   
    CTmeans_sh(i,j)=mean(nanmean(thisSess_sh));
    CTstd_sh(i,j)=mean(nanstd(thisSess_sh));
    end
end
%CT(CT==1)=NaN;CT(CT==0)=NaN;
%var2=var(CT_sh,'omitnan'); var2=mean(var2);
% 
% DecodeInt(:,:,hh)=CTmeans;
% DecodeInt_sh(:,:,hh)=CTmeans_sh;

clear evs_matrix*
cd ..

% Perf(:,:,hh)=(CTmeans-CTmeans_sh)/(sqrt(var1^2 +var2^2));

end


DiffDecode=CTmeans-CTmeans_sh;
%DiffDecode=DiffDecode+.5;
    
    