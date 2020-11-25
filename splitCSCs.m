
timeStamps=R.TimeStamps(1,:);
%find closet values in post
closest=zeros(length(timeStamps),1);
val=zeros(length(timeStamps),1);

CSC_times=R.CSC.CSC1_TimeStamps'-R.CSC.CSC1_TimeStamps(1);
for r=(1:length(timeStamps))
    q=CSC_times;
    val_1 = timeStamps(r); %value to find
    val(r)=cell2mat(val_1);
end

%find a less stupid way to do this (the for loop doesn't like f-val(i)
    tmp = abs(q-val(1));
    [idx idx]= min(tmp); %index of closest value
    closest(1) = q(idx); %closest value

    tmp = abs(q-val(2));
    [idx idx] = min(tmp); %index of closest value
    closest(2) = q(idx); %closest value
    
    tmp = abs(q-val(3));
    [idx idx] = min(tmp); %index of closest value
    closest(3) = q(idx); %closest value
    
    tmp = abs(q-val(4));
    [idx idx] = min(tmp); %index of closest value
    closest(4) = q(idx); %closest value
    
    tmp = abs(q-val(5));
    [idx idx] = min(tmp); %index of closest value
    closest(5) = q(idx); %closest value
   
    tmp = abs(q-val(6));
    [idx idx] = min(tmp); %index of closest value
    closest(6) = q(idx); %closest value
    
    tmp = abs(q-val(7));
    [idx idx] = min(tmp); %index of closest value
    closest(7) = q(idx); %closest value
    
    tmp = abs(q-val(8));
    [idx idx] = min(tmp); %index of closest value
    closest(8) = q(idx); %closest value
    
    %commented out for cfc
    tmp = abs(q-val(9));
    [idx idx] = min(tmp); %index of closest value
    closest(9) = q(idx); %closest value
    
    tmp = abs(q-val(10));
    [idx idx] = min(tmp); %index of closest value
    closest(10) = q(idx); %closest value
    
%      tmp = abs(q-val(11));
%     [idx idx] = min(tmp); %index of closest value
%     closest(11) = q(idx); %closest value
%     
%     tmp = abs(q-val(12));
%     [idx idx] = min(tmp); %index of closest value
%     closest(12) = q(idx); %closest value
%split posx and posx

%split hab habstart=1 habend=2
habtimes= find ((CSC_times>closest(1)&CSC_times<closest(2)));
hab.CSC1ts= CSC_times(habtimes);
habCSC1= R.CSC.CSC1_Samples(:,habtimes); [hab.CSC1,hab.CSC1ts]=straightenCSC(habCSC1,hab.CSC1ts);
habCSC2= R.CSC.CSC2_Samples(:,habtimes); hab.CSC2=straightenCSC(habCSC2,hab.CSC1ts);
habCSC3= R.CSC.CSC3_Samples(:,habtimes); hab.CSC3=straightenCSC(habCSC3,hab.CSC1ts);
habCSC4= R.CSC.CSC4_Samples(:,habtimes); hab.CSC4=straightenCSC(habCSC4,hab.CSC1ts);
habCSC5= R.CSC.CSC5_Samples(:,habtimes); hab.CSC5=straightenCSC(habCSC5,hab.CSC1ts);
habCSC6= R.CSC.CSC6_Samples(:,habtimes); hab.CSC6=straightenCSC(habCSC6,hab.CSC1ts);
habCSC7= R.CSC.CSC7_Samples(:,habtimes); hab.CSC7=straightenCSC(habCSC7,hab.CSC1ts);


%split cups cupsstart=2 cups end=3
cuptimes= find ((CSC_times>closest(3)&CSC_times<closest(4)));
cup.CSC1ts= CSC_times(cuptimes);
cupCSC1= R.CSC.CSC1_Samples(:,cuptimes); [cup.CSC1,cup.CSC1ts]=straightenCSC(cupCSC1,cup.CSC1ts);
cupCSC2= R.CSC.CSC2_Samples(:,cuptimes); cup.CSC2=straightenCSC(cupCSC2,cup.CSC1ts);
cupCSC3= R.CSC.CSC3_Samples(:,cuptimes); cup.CSC3=straightenCSC(cupCSC3,cup.CSC1ts);
cupCSC4= R.CSC.CSC4_Samples(:,cuptimes); cup.CSC4=straightenCSC(cupCSC4,cup.CSC1ts);
cupCSC5= R.CSC.CSC5_Samples(:,cuptimes); cup.CSC5=straightenCSC(cupCSC5,cup.CSC1ts);
cupCSC6= R.CSC.CSC6_Samples(:,cuptimes); cup.CSC6=straightenCSC(cupCSC6,cup.CSC1ts);
cupCSC7= R.CSC.CSC7_Samples(:,cuptimes); cup.CSC7=straightenCSC(cupCSC7,cup.CSC1ts);

%split fam1 fam1start=3 end=4
fam1times= find ((CSC_times>closest(5)&CSC_times<closest(6)));
fam1.CSC1ts= CSC_times(fam1times);
fam1CSC1= R.CSC.CSC1_Samples(:,fam1times); [fam1.CSC1,fam1.CSC1ts]=straightenCSC(fam1CSC1,fam1.CSC1ts);
fam1CSC2= R.CSC.CSC2_Samples(:,fam1times); fam1.CSC2=straightenCSC(fam1CSC2,fam1.CSC1ts);
fam1CSC3= R.CSC.CSC3_Samples(:,fam1times); fam1.CSC3=straightenCSC(fam1CSC3,fam1.CSC1ts);
fam1CSC4= R.CSC.CSC4_Samples(:,fam1times); fam1.CSC4=straightenCSC(fam1CSC4,fam1.CSC1ts);
fam1CSC5= R.CSC.CSC5_Samples(:,fam1times); fam1.CSC5=straightenCSC(fam1CSC5,fam1.CSC1ts);
fam1CSC6= R.CSC.CSC6_Samples(:,fam1times); fam1.CSC6=straightenCSC(fam1CSC6,fam1.CSC1ts);
fam1CSC7= R.CSC.CSC7_Samples(:,fam1times); fam1.CSC7=straightenCSC(fam1CSC7,fam1.CSC1ts);

%split novel novelstart=4 end=5
novtimes= find ((CSC_times>closest(7)&CSC_times<closest(8)));
nov.CSC1ts= CSC_times(novtimes);
novCSC1= R.CSC.CSC1_Samples(:,novtimes); [nov.CSC1,nov.CSC1ts]=straightenCSC(novCSC1,nov.CSC1ts);
novCSC2= R.CSC.CSC2_Samples(:,novtimes); nov.CSC2=straightenCSC(novCSC2,nov.CSC1ts);
novCSC3= R.CSC.CSC3_Samples(:,novtimes); nov.CSC3=straightenCSC(novCSC3,nov.CSC1ts);
novCSC4= R.CSC.CSC4_Samples(:,novtimes); nov.CSC4=straightenCSC(novCSC4,nov.CSC1ts);
novCSC5= R.CSC.CSC5_Samples(:,novtimes); nov.CSC5=straightenCSC(novCSC5,nov.CSC1ts);
novCSC6= R.CSC.CSC6_Samples(:,novtimes); nov.CSC6=straightenCSC(novCSC6,nov.CSC1ts);
novCSC7= R.CSC.CSC7_Samples(:,novtimes); nov.CSC7=straightenCSC(novCSC7,nov.CSC1ts);

%split fam 2 fam2 start=5 end=6
fam2times= find ((CSC_times>closest(9)&CSC_times<closest(10)));
fam2.CSC1ts= CSC_times(fam2times);
fam2CSC1= R.CSC.CSC1_Samples(:,fam2times); [fam2.CSC1,fam2.CSC1ts]=straightenCSC(fam2CSC1,fam2.CSC1ts);
fam2CSC2= R.CSC.CSC2_Samples(:,fam2times); fam2.CSC2=straightenCSC(fam2CSC2,fam2.CSC1ts);
fam2CSC3= R.CSC.CSC3_Samples(:,fam2times); fam2.CSC3=straightenCSC(fam2CSC3,fam2.CSC1ts);
fam2CSC4= R.CSC.CSC4_Samples(:,fam2times); fam2.CSC4=straightenCSC(fam2CSC4,fam2.CSC1ts);
fam2CSC5= R.CSC.CSC5_Samples(:,fam2times); fam2.CSC5=straightenCSC(fam2CSC5,fam2.CSC1ts);
fam2CSC6= R.CSC.CSC6_Samples(:,fam2times); fam2.CSC6=straightenCSC(fam2CSC6,fam2.CSC1ts);
fam2CSC7= R.CSC.CSC7_Samples(:,fam2times); fam2.CSC7=straightenCSC(fam2CSC7,fam2.CSC1ts);

clearvars -except hab cup fam1 nov fam2 R
