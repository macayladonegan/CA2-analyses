TTs=ls('TT*.spikes');kk=size(TTs);
for aa=1:kk(1)
    thisTT=TTs(aa,:);
    thisTT=strtrim(thisTT);
    [TTdata,TTtimestamps, TTinfo]=load_open_ephys_data_faster(thisTT);
    TTdata=permute(TTdata,[3 2 1]);
    thisTTname=strcat('TT',num2str(aa));
    save(thisTTname,'TTdata')
end

