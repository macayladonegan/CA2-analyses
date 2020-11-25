animalIDs=ls('*3chamber*');
sessions={'hab', 'cups', 'fam1', 'nov','fam2'};
yy=size(animalIDs);

for hh=1:yy(1)
    cd(animalIDs(hh,1:end))
       list_cells=num2str(ls('TT*unit*'));
       load('hab_means.mat');load('hab_stds.mat')
    for j=1:length(list_cells)
        cd(list_cells(j,1:end))
        for k=1:length(sessions)
        thisSession=sessions(k);
        thisSession=cellstr(thisSession); 
        thisSession=char(thisSession);
        cd(thisSession)
        load('leftCup.mat');load('rightCup.mat');
        if isempty(leftCup{4})
            frL=NaN;
        else
        frL=leftCup{7}/length(leftCup{4});
        end
        if isempty(rightCup{4})
           frR=NaN;
        else
        frR=rightCup{7}/length(rightCup{4});
        end
        
        frL_norm=(frL-(mean(means(j,:))))/mean(stds(j,:));
        frR_norm=(frR-mean(means(j,:)))/mean(stds(j,:));
        DiscriminationIndex(j,k)=(frL-frR)/(frL+frR);
        cd ..
        end
        cd ..
    end
    DiscriminationIndexes{hh}=DiscriminationIndex(:,:);
    clear DiscriminationIndex
    %FR_all{hh}=frL_norm;
    cd ..
end

DIs=vertcat(DiscriminationIndexes{:});