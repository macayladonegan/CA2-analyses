%find closet values in post
timeStamps=cell2mat(timeStamps);
closest=zeros(length(timeStamps),1);
val=zeros(length(timeStamps),1);

for r=(1:length(timeStamps))
    q= post;
    val_1 = timeStamps(r); %value to find
    val(r)=(val_1);
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
    
    %%commented out for cfc
    tmp = abs(q-val(9));
    [idx idx] = min(tmp); %index of closest value
    closest(9) = q(idx); %closest value
    
    tmp = abs(q-val(10));
    [idx idx] = min(tmp); %index of closest value
    closest(10) = q(idx); %closest value
%     
%      tmp = abs(q-val(11));
%     [idx idx] = min(tmp); %index of closest value
%     closest(11) = q(idx); %closest value
%     
%     tmp = abs(q-val(12));
%     [idx idx] = min(tmp); %index of closest value
%     closest(12) = q(idx); %closest value
% %split posx and posx

%split hab habstart=1 habend=2
Split.hab.times= find ((post>closest(1)&post<closest(2)));
Split.hab.post= post(Split.hab.times);
Split.hab.posx= posx(Split.hab.times);
Split.hab.posy= posy(Split.hab.times);

%split cups cupsstart=2 cups end=3
Split.cups.times= find ((post>closest(3)&post<closest(4)));
Split.cups.post= post(Split.cups.times);
Split.cups.posx= posx(Split.cups.times);
Split.cups.posy= posy(Split.cups.times);

%split fam1 fam1start=3 end=4
Split.fam1.times= find ((post>closest(5)&post<closest(6)));
Split.fam1.post= post(Split.fam1.times);
Split.fam1.posx= posx(Split.fam1.times);
Split.fam1.posy= posy(Split.fam1.times);

%split novel novelstart=4 end=5
Split.nov.times= find ((post>closest(7)&post<closest(8)));
Split.nov.post= post(Split.nov.times);
Split.nov.posx= posx(Split.nov.times);
Split.nov.posy= posy(Split.nov.times);

% %split fam 2 fam2 start=5 end=6
Split.fam2.times= find ((post>closest(9)&post<closest(10)));
Split.fam2.post= post(Split.fam2.times);
Split.fam2.posx= posx(Split.fam2.times);
Split.fam2.posy= posy(Split.fam2.times);

% %split novel novelstart=4 end=5
% Split.nov2.times= find ((post>closest(11)&post<closest(12)));
% Split.nov2.post= post(Split.nov2.times);
% Split.nov2.posx= posx(Split.nov2.times);
% Split.nov2.posy= posy(Split.nov2.times);
% 



%establish pos variables where there are spikes
spk_post=cell2mat(ts);
spk_posx=cell2mat(spkx);
spk_posy=cell2mat(spky);

if length(spk_posx)~=length(cell2mat(spkx))
    disp ('FAILED');
    msgbox ('missing spike data')
    return
end


%split spks into sessions
hab_spk_post_ind= find(spk_post>min(Split.hab.post)&spk_post<max(Split.hab.post));
Split.hab.spkt=spk_post(hab_spk_post_ind);
Split.hab.spkx=spk_posx(hab_spk_post_ind);
Split.hab.spky=spk_posy(hab_spk_post_ind);
Split.numSpks.hab=length(Split.hab.spkt);

cups_spk_post_ind= find(spk_post>min(Split.cups.post)&spk_post<max(Split.cups.post));
Split.cups.spkt=spk_post(cups_spk_post_ind);
Split.cups.spkx=spk_posx(cups_spk_post_ind);
Split.cups.spky=spk_posy(cups_spk_post_ind);
Split.numSpks.cups=length(Split.cups.spkt);

fam1_spk_post_ind= find(spk_post>min(Split.fam1.post)&spk_post<max(Split.fam1.post));
Split.fam1.spkt=spk_post(fam1_spk_post_ind);
Split.fam1.spkx=spk_posx(fam1_spk_post_ind);
Split.fam1.spky=spk_posy(fam1_spk_post_ind);
Split.numSpks.fam1=length(Split.fam1.spkt);

nov_spk_post_ind= find(spk_post>min(Split.nov.post)&spk_post<max(Split.nov.post));
Split.nov.spkt=spk_post(nov_spk_post_ind);
Split.nov.spkx=spk_posx(nov_spk_post_ind);
Split.nov.spky=spk_posy(nov_spk_post_ind);
Split.numSpks.nov=length(Split.nov.spkt);

fam2_spk_post_ind= find(spk_post>min(Split.fam2.post)&spk_post<max(Split.fam2.post));
Split.fam2.spkt=spk_post(fam2_spk_post_ind);
Split.fam2.spkx=spk_posx(fam2_spk_post_ind);
Split.fam2.spky=spk_posy(fam2_spk_post_ind);
Split.numSpks.fam2=length(Split.fam2.spkt);

% nov2_spk_post_ind= find(spk_post>min(Split.nov2.post)&spk_post<max(Split.nov2.post));
% Split.nov2.spkt=spk_post(nov2_spk_post_ind);
% Split.nov2.spkx=spk_posx(nov2_spk_post_ind);
% Split.nov2.spky=spk_posy(nov2_spk_post_ind);
% Split.numSpks.nov2=length(Split.nov2.spkt);


%save into cell arrays
save('Split','Split')

% clearvars;












