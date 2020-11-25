%%load Spikes
TTs=ls('Binaries*'); sizeTTs=size(TTs);

for jj=1:sizeTTs(1)
    thisTT=TTs(jj,1:end);
    cd(thisTT)
    
    spikeStruct = loadKSdir(pwd);
    numClust=length(spikeStruct.cids);
    
    for ii=1:numClust
        if spikeStruct.cgs(1,ii)==2
            thisClust=spikeStruct.cids(ii);
            spikeInds=find(spikeStruct.clu==thisClust);
            spikeTimes{ii,jj}=spikeStruct.st(spikeInds);
        end
    end
    clear spikeStruct
    cd ..
    
end

%%load Positions
sessions=ls('tracking*'); sizeS=size(sessions);

for jj=1:sizeS(1)
    thisPos=load(sessions(jj,1:end));
    [x,y,t]=CleanPos(thisPos.xytl);
    
end

