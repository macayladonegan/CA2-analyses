list_cells=num2str(ls('TT*unit*'));
vel=.5;
sessions={'hab', 'cups', 'fam1', 'nov','fam2'};
load('R.mat')
corr_mat=cell(length(list_cells),5);
for i=1:length(list_cells)
    thisCell=list_cells(i,1:8);
    cd(thisCell)
    load('Split.mat')
    for j=1:length(sessions)
        thisSession=sessions{j};
        cd(thisSession)
        map=splitMaps(Split,R,vel);
        thismap=strcat('map.',thisSession);
        thismap=eval(thismap);
        thismap(isnan(thismap))=0;
        corr_mat{i,j}=thismap;
        cd ..
    end
    cd ..
    
end

save('corr_mat','corr_mat')


%now use corr_mat to look at spatial correlation between sessions
sess_corr=zeros(length(corr_mat),(length(sessions)-1));
p_vals=zeros(length(corr_mat),(length(sessions)-1));
for ii=1:length(list_cells)
    for jj=1:length(sessions)-1
        sess1=corr_mat{ii,jj};
        sess2=corr_mat{ii,jj+1};
        [r,p]=corrcoef(sess1,sess2);
        sess_corr(ii,jj)=r(2,1);
        p_vals(ii,jj)=p(2,1);
    end
end

xlswrite('corrcoeff_sess.xlsx',sess_corr_unfilt)




