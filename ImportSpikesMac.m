list_cells=num2str(ls('TT*unit*'));
sessions={'hab', 'cups', 'fam1', 'nov', 'fam2'};

spikes=cell(length(list_cells),length(sessions));
for jj=1:length(sessions)
    thisSession=sessions(jj);
    thisSession=cellstr(thisSession);
    thisSession=char(thisSession);
    
    for ii=1:length(list_cells)
       thisCell=list_cells(ii,1:8);
       cd(thisCell)
       load spkpos.mat
       these_ts=strcat(thisSession,'_spk_post');
       theseSpikes=eval(these_ts);
       spikes{ii,jj}=theseSpikes(:);
       cd ..
    end
    
end

save 'Spikes.mat' list_cells spikes