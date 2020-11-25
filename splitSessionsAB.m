timeStamps=timeStamps(1,:);
%find closet values in post
closest=zeros(length(timeStamps),1);
val=zeros(length(timeStamps),1);
for r=(1:length(timeStamps))
    q= post;
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
    

%split hab habstart=1 habend=2
Split.ab.times= find ((post>closest(1)&post<closest(2)));
Split.ab.post= post(Split.ab.times);
Split.ab.posx= posx(Split.ab.times);
Split.ab.posy= posy(Split.ab.times);

%split cups cupsstart=2 cups end=3
Split.ba.times= find ((post>closest(3)&post<closest(4)));
Split.ba.post= post(Split.ba.times);
Split.ba.posx= posx(Split.ba.times);
Split.ba.posy= posy(Split.ba.times);

%split fam1 fam1start=3 end=4
Split.empty.times= find ((post>closest(5)&post<closest(6)));
Split.empty.post= post(Split.empty.times);
Split.empty.posx= posx(Split.empty.times);
Split.empty.posy= posy(Split.empty.times);

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
ab_spk_post_ind= find(spk_post>min(Split.ab.post)&spk_post<max(Split.ab.post));
Split.ab.spkt=spk_post(ab_spk_post_ind);
Split.ab.spkx=spk_posx(ab_spk_post_ind);
Split.ab.spky=spk_posy(ab_spk_post_ind);
Split.numSpks.ab=length(Split.ab.spkt);

ba_spk_post_ind= find(spk_post>min(Split.ba.post)&spk_post<max(Split.ba.post));
Split.ba.spkt=spk_post(ba_spk_post_ind);
Split.ba.spkx=spk_posx(ba_spk_post_ind);
Split.ba.spky=spk_posy(ba_spk_post_ind);
Split.numSpks.ba=length(Split.ba.spkt);

empty_spk_post_ind= find(spk_post>min(Split.empty.post)&spk_post<max(Split.empty.post));
Split.empty.spkt=spk_post(empty_spk_post_ind);
Split.empty.spkx=spk_posx(empty_spk_post_ind);
Split.empty.spky=spk_posy(empty_spk_post_ind);
Split.numSpks.empty=length(Split.empty.spkt);

save('Split','Split')

% clearvars;
