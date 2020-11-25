%load('R')
Spikes=R.Spike.t(~cellfun('isempty',R.Spike.t)); 

%R.Pos.t=Events.timestamps(1):1/fps:Events.timestamps(end);
%%subsample R.Pos.t
%pos_ss=R.Pos.t(1:ss:end);
pos_ss=Events.timestamps(1):1/fps:Events.timestamps(end);
pos_ss=pos_ss-pos_ss(1);
R.Pos.t=pos_ss;
save('R','R')

for bb=1:length(Spikes)
    theseSpikes=Spikes{bb,1};

    for r=(1:length(theseSpikes))
        q= pos_ss;
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
    holder=histcounts(theseInds{z,1},0:length(pos_ss));
    evs_matrix_ss(z,:)=holder;
    clear holder
end



save('evs_matrix','evs_matrix_ss')
%clearvars -except evs_matrix_ss ss hh yy animalIDs DecodeInt DecodeInt_sh Stats
clear memory
