
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
    
    tmp = abs(q-val(7));
    [idx idx] = min(tmp); %index of closest value
    closest(7) = q(idx); %closest value
    
    tmp = abs(q-val(8));
    [idx idx] = min(tmp); %index of closest value
    closest(8) = q(idx); %closest value
    

%split hab habstart=1 habend=2
Split.sleep1.times= find ((post>closest(1)&post<closest(2)));
Split.sleep1.post= post(Split.sleep1.times);
Split.sleep1.posx= posx(Split.sleep1.times);
Split.sleep1.posy= posy(Split.sleep1.times);

%split cups cupsstart=2 cups end=3
Split.OF1.times= find ((post>closest(3)&post<closest(4)));
Split.OF1.post= post(Split.OF1.times);
Split.OF1.posx= posx(Split.OF1.times);
Split.OF1.posy= posy(Split.OF1.times);

%split fam1 fam1start=3 end=4
Split.sleep2.times= find ((post>closest(5)&post<closest(6)));
Split.sleep2.post= post(Split.sleep2.times);
Split.sleep2.posx= posx(Split.sleep2.times);
Split.sleep2.posy= posy(Split.sleep2.times);

%split novel novelstart=4 end=5
Split.OF2.times= find ((post>closest(7)&post<closest(8)));
Split.OF2.post= post(Split.OF2.times);
Split.OF2.posx= posx(Split.OF2.times);
Split.OF2.posy= posy(Split.OF2.times);

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
sleep1_spk_post_ind= find(spk_post>min(Split.sleep1.post)&spk_post<max(Split.sleep1.post));
Split.sleep1.spkt=spk_post(sleep1_spk_post_ind);
Split.sleep1.spkx=spk_posx(sleep1_spk_post_ind);
Split.sleep1.spky=spk_posy(sleep1_spk_post_ind);
Split.numSpks.sleep1=length(Split.sleep1.spkt);

OF1_spk_post_ind= find(spk_post>min(Split.OF1.post)&spk_post<max(Split.OF1.post));
Split.OF1.spkt=spk_post(OF1_spk_post_ind);
Split.OF1.spkx=spk_posx(OF1_spk_post_ind);
Split.OF1.spky=spk_posy(OF1_spk_post_ind);
Split.numSpks.OF1=length(Split.OF1.spkt);

sleep2_spk_post_ind= find(spk_post>min(Split.sleep2.post)&spk_post<max(Split.sleep2.post));
Split.sleep2.spkt=spk_post(sleep2_spk_post_ind);
Split.sleep2.spkx=spk_posx(sleep2_spk_post_ind);
Split.sleep2.spky=spk_posy(sleep2_spk_post_ind);
Split.numSpks.sleep2=length(Split.sleep2.spkt);

OF2_spk_post_ind= find(spk_post>min(Split.OF2.post)&spk_post<max(Split.OF2.post));
Split.OF2.spkt=spk_post(OF2_spk_post_ind);
Split.OF2.spkx=spk_posx(OF2_spk_post_ind);
Split.OF2.spky=spk_posy(OF2_spk_post_ind);
Split.numSpks.OF2=length(Split.OF2.spkt);


%save into cell arrays
save('Split','Split')

% clearvars;











