%find closet values in post
closest=zeros(length(timeStamps),1);
val=zeros(length(timeStamps),1);
for r=(1:length(timeStamps))
    q= post;
    val_1 = timeStamps(r); %value to find
    val(r)=(val_1);
end

for ii=1:length(val)
    tmp = abs(q-val(ii));
    [idx idx]= min(tmp); %index of closest value
    closest(ii) = q(idx); %closest value
    
    clear idx
end

spk_post=cell2mat(ts);
spk_posx=cell2mat(spkx);
spk_posy=cell2mat(spky);

if length(spk_posx)~=length(cell2mat(spkx))
    disp ('FAILED');
    msgbox ('missing spike data')
    return
end

for numSplits=1:length(closest)/2
    Split(numSplits).times=find (post>closest(2*numSplits-1) & post<closest(2*numSplits));
    Split(numSplits).post= post(Split(numSplits).times);
    Split(numSplits).posx= posx(Split(numSplits).times);
    Split(numSplits).posy= posy(Split(numSplits).times);
    spk_post_ind= find(spk_post>min(Split(numSplits).post)&spk_post<max(Split(numSplits).post));
    
    Split(numSplits).spkt=spk_post(spk_post_ind);
    if ~isempty(spk_posx)
    Split(numSplits).spkx=spk_posx(spk_post_ind);
    Split(numSplits).spky=spk_posy(spk_post_ind);
    
    else
    Split(numSplits).spkx=NaN;
    Split(numSplits).spky=NaN;
    end
end


save('Split','Split')












