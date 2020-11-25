sessions={'hab', 'cups', 'fam1', 'novel','fam2'};

for ii=1:length(sessions)
    thisfile=strcat('output_',sessions{ii},'.txt');
    fID=fopen(thisfile,'r');
    A=fscanf(fID,'%f',[11 inf]);
    for jj=min(A(1,:)):max(A(1,:))
        theseInds=find(A(1,:)==jj);
        theseScores=A(2:end,theseInds);
        mean_scores(ii,jj)=mean(mean(theseScores'));
        mean_std(ii,jj)=mean(std(theseScores'));
    end
    
end


shadedErrorBar(min(A(1,:)):max(A(1,:)),mean(mean_scores(:,2:end)),mean(mean_std(:,2:end)))