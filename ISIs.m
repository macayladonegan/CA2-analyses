%%ISIs
animalIDs=ls('*3chamber*');
sessions={'hab', 'cups', 'fam1', 'nov','fam2'};
yy=size(animalIDs);

for hh=1:yy(1)
    cd(animalIDs(hh,1:end))
       list_cells=num2str(ls('TT*unit*'));
    for j=1:length(list_cells)
        cd(list_cells(j,1:end))
        for k=1:length(sessions)
        thisSession=sessions(k);
        thisSession=cellstr(thisSession); 
        thisSession=char(thisSession);
        load('Split.mat')
        spkt=eval(strcat('Split.',thisSession,'.spkt'));
        isi{j,k}=diff(spkt);
        mean_isi(j,k)=mean(isi{j,k});
        end
        cd ..
    end
    cd ..
    allISIs{hh}=isi;
    meanISIs{hh}=mean_isi;
    clear isi mean_isi
end
%% means

for hh=1:yy(1)
    means(1:5,hh)=nanmean(meanISIs{1,hh});
    sems(1:5,hh)=nansem(meanISIs{1,hh}); 
    means=mean(means');sems=mean(sems');
end
%% isi during interations
for hh=1:yy(1)
    cd(animalIDs(hh,1:end))
       list_cells=num2str(ls('TT*unit*'));
    for j=1:length(list_cells)
        cd(list_cells(j,1:end))
        for k=1:length(sessions)
        thisSession=sessions(k);
        thisSession=cellstr(thisSession); 
        thisSession=char(thisSession);  cd(thisSession)
        load('leftCup.mat')
        
        isi{j,k}=diff(leftCup{1,3});
        isi{j,k}(isi{j,k}>mean(allISIs{1,hh}{j,k})+2*std(allISIs{1,hh}{j,k}))= NaN; %%find a smarter way to do this
        mean_isi(j,k)=nanmean(isi{j,k});
        cd ..
        end
        cd ..
    end
    cd ..
    allISIs_int{hh}=isi;
    meanISIs_int{hh}=mean_isi;
    clear isi mean_isi
end
%% 
for hh=1:yy(1)
    means_int(1:5,hh)=nanmean(meanISIs_int{1,hh});
    sems_int(1:5,hh)=nansem(meanISIs_int{1,hh}); 
    
end


%% means_int=mean(means_int');sems_it=mean(sems_int');


