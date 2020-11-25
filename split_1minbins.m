%split into smaller time bins
create_timeStamps
timeStamps=cell2mat(timeStamps);
timeStamps_start=[timeStamps(1) timeStamps(3) timeStamps(5) timeStamps(7) timeStamps(9)];
%is there a way to do this with a for loop
%break up each session minute by minute- just do this approximately? divide
%the session by 10?

one_minBins=ones(length(timeStamps_start),10);
for r=1:length(timeStamps_start)
    one_minBins(r,1)=timeStamps_start(r);
    for s=2:10
        split_times=(timeStamps((2*r))-timeStamps_start(r))/10;
        one_minBins(r,s)=timeStamps_start(r)+(s*split_times);
    end
end

save('one_minBins.mat','one_minBins')