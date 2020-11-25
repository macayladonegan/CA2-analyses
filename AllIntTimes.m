list_cells=num2str(ls('TT*unit*'));

sessions={'hab', 'cups', 'fam1', 'novel', 'fam2'};
for i= 1:length(list_cells)
    thisCell=list_cells(i,1:8);
    cd(thisCell);
    figure(1)
    
    spksPerSess=ones(1,length(sessions));
    for j=1:length(sessions)
        session=sessions{j};
        cd(session)
        load('leftCup.mat')
        subplot(length(sessions),1,j)
        plot(leftCup{5},leftCup{6},'k')
        hold on
        plot(leftCup{1},leftCup{2},'or')
        set(gca, 'XTick', [], 'YTick', [])
        title(session)
        hold off
        spksPerSess(j)=leftCup{7};
        clearvars -except list_cells sessions spksPerSess
        
        cd ..
    end

    saveas(figure(1), 'leftCup_plot')
    save('spksPerSess_left','spksPerSess')
    cd ..
end


for i= 1:length(list_cells)
    thisCell=list_cells(i,1:8);
    cd(thisCell);
    figure(2)
    
    spksPerSess=ones(1,length(sessions));
    for j=1:length(sessions)
        session=sessions{j};
        cd(session)
        load('rightCup.mat')
        subplot(length(sessions),1,j)
        plot(rightCup{5},rightCup{6},'k')
        hold on
        plot(rightCup{1},rightCup{2},'or')
        hold off
        set(gca, 'XTick', [], 'YTick', [])
        title(session)
        
        spksPerSess(j)=rightCup{7};
        clearvars -except list_cells sessions spksPerSess
        
        cd ..
    end

    saveas(figure(2), 'rightCup_plot')
    save('spksPerSess_right','spksPerSess')
    cd ..
end

clear
close all
