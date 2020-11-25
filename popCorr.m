list_cells=num2str(ls('TT*unit*'));

sessions={'hab', 'cups', 'fam1', 'novel', 'fam2'};

pop_mat=cell(1,length(sessions));
for j=1:length(sessions)
    thisSession=sessions(j);
    thisSession=cellstr(thisSession);
    thisSession=char(thisSession);
    allmaps=cell(length(list_cells),1);
    
    
    for i=1:length(list_cells)
       thisCell=list_cells(i,1:8);
       cd(thisCell)
       cd(thisSession)
       load('map.mat')
       map(isnan(map))=0;
       map=reshape(map,1,65*65);
       allmaps{i}=map;
       cd ..
       cd ..
    end
    maps=cell2mat(allmaps);
    pop_mat{1,j}=maps;
end


pop_corr=zeros(1,(length(sessions)-1));
p_vals=zeros(1,(length(sessions)-1));

    for jj=1:length(sessions)-1;
        sess1=pop_mat{1,jj};
        sess2=pop_mat{1,jj+1};
        [r,p]=corrcoef(sess1,sess2);
        pop_corr(1,jj)=r(2,1);
        p_vals(1,jj)=p(2,1);
    end
    
    xlswrite('popCorr.xlsx',pop_corr)