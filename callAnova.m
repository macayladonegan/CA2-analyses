%anova between sessions



list_cells=num2str(ls('TT*unit*'));
sessions={'hab', 'cups', 'fam1', 'novel', 'fam2'};
pop_mat=cell(1,length(sessions));
for j=1:length(sessions)
    thisSession=sessions(j);
    thisSession=cellstr(thisSession);
    thisSession=char(thisSession);
    allmaps=cell(length(list_cells),1);
    
    
    for i=1:length(list_cells)
       thisCell=list_cells(i,1:9);
       cd(thisCell)
       cd(thisSession)
       load('map.mat')
       map(isnan(map))=0;
       a=length(map);
       map=reshape(map,1,a*a);
       allmaps{i}=map;
       cd ..
       cd ..
    end
    maps=cell2mat(allmaps);
    pop_mat{1,j}=maps;
end

var=ones(length(list_cells),length(sessions)-1);
for j=1:length(sessions)-1
    corrSession=pop_mat{:,j};
    corrSession1=pop_mat{:,j+1};
    
    for i=1:length(list_cells)
       comp1=corrSession(i,:)';
       comp2=corrSession1(i,:)';
       comp_mat=[comp1 comp2];
       [var(i,j),~,stats]=anova1(comp_mat);
       %if you don't close this IT WILL CRASH MATLAB
       close all

       
    end
end

save 'anova' 'var'