clear evs_matrix
Spikes=R.Spike.t(~cellfun('isempty',R.Spike.t)); 



parfor bb=1:length(Spikes)
    theseSpikes=Spikes{bb,1};
    val=zeros(length(theseSpikes));
    for r=(1:length(theseSpikes))
        q= R.Pos.t;
        val(r) = theseSpikes(r); %value to find
    end
    
    closest_ind=ones(1,length(theseSpikes));
    for aa=1:length(theseSpikes)
        tmp = abs(q-val(aa));
        [idx idx]= min(tmp); %index of closest value
        closest_ind(aa)=idx;
        theseInds{bb,1}=closest_ind;
    end
end



for z=1:length(Spikes)
    holder=histcounts(theseInds{z,1},length(R.Pos.t));
    evs_matrix(z,:)=holder;
    clear holder
end

save('evs_matrix','evs_matrix')
