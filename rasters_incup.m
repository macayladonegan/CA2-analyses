list_cells=num2str(ls('TT*unit*'));
sessions={'hab', 'cups', 'fam1', 'novel', 'fam2'};

%If a tetrode has more than 10 cells, use 1:9 instead of 1:8

    for j=1:length(sessions)
    session=sessions{j};
    figure(j)
    for i= 1:length(list_cells)
        thisCell=list_cells(i,1:8);
        cd(thisCell);
        
        cd (session);
        load ('leftCup.mat')
        ts_in_L=leftCup{3};
        ts_in_L=ts_in_L';
        post_in_L=leftCup{4};
        diff_Ts=diff(post_in_L);
        inds=diff_Ts>1;
        inds=find(inds==1);
        breaks=post_in_L(inds)';
        
        name=strcat(session,'leftCup');
        
        subplot(length(list_cells),1,i)

        plot([ts_in_L;ts_in_L],[ones(size(ts_in_L));zeros(size(ts_in_L))],'k-')
        hold on
        plot([breaks;breaks],[ones(size(breaks));zeros(size(breaks))],'r-')
        axis([min(post_in_L) max(post_in_L) -0 1])
        
        
        set(gca, 'XTickLabelMode', 'Manual')
        set(gca, 'XTick', [])
                
        set(gca, 'YTickLabelMode', 'Manual')
        set(gca, 'YTick', [])
        cd ..
        cd ..

    end
    suptitle(name)
    set(gca,'XTickLabelMode', 'auto')
    %set(gca, 'XTick', [0 max(post_in_L)])
    saveas (figure(j),name)
    
    clearvars -except list_cells sessions
    close all

    end



% figure() 
% for j=1:length(sessions)
%     session=sessions{j};
%     for i= 1:length(list_cells)
%     thisCell=list_cells(i,1:8);
%     cd(thisCell);
% 
%     cd (session);
%     load ('rightCup.mat')
%     ts_in_R=rightCup{3};
%     ts_in_R=ts_in_R';
%     post_in_R=rightCup{4};
%     
%     subplot(length(list_cells),1,i);
%     plot([ts_in_R;ts_in_R],[ones(size(ts_in_R));zeros(size(ts_in_R))],'k-')
%     axis([min(post_in_R) max(post_in_R)+1 -0 1])
%     name=strcat(session,'rightCup');
%     title(name)
%     set(gca, 'XTickLabelMode', 'Manual')
%     set(gca, 'XTick', [])
%     cd ..
%     cd ..
%     
%     end
%     saveas(figure,name)
%     clearvars -except list_cells sessions
%     close all
%     
% 
% end

