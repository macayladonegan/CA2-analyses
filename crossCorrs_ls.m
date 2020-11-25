%%
%PLOT CROSSCORRELATION, FOR CLEANED DATA
%produces heatmap of component CrossCorr
 ts_in_L=cell(length(list_cells),1);
for unitNum=1:length(list_cells);
    thisCell=list_cells(unitNum,1:9);
    cd(thisCell);
    cd (session);
    load('leftCup.mat')
    ts_in_L{unitNum,1}=leftCup{3};
    cd ..
    cd ..
    for unitNum2 = 1:length(list_cells);
        thisCell=list_cells(unitNum2,1:9);
        cd(thisCell);
        cd (session);
        load('leftCup.mat')
        ts_in_L{unitNum2,1}=leftCup{3};
        cd ..
        [xc, lags] = xcorr(ts_in_L{unitNum,1}, ts_in_L{unitNum2,1}, 5);
        xcMat(unitNum, unitNum2) = max(xc);
        cd ..
    end
end
 
figure(1);hold on;
colormap('hot');
imagesc(xcMat)
colorbar;
title('Crosscorrelation of Components_left_cup');
xlabel('Component');
ylabel('Component');
hold off;
saveas(figure(1), left_cup_xcorr)

clearvars -except session list_cells

 ts_in_R=cell(length(list_cells),1);
for unitNum=1:length(list_cells);
    thisCell=list_cells(unitNum,1:9);
    cd(thisCell);
    cd (session);
    load('rightCup.mat')
    ts_in_R{unitNum,1}=leftCup{3};
    cd ..
    cd ..
    for unitNum2 = 1:length(list_cells);
        thisCell=list_cells(unitNum2,1:9);
        cd(thisCell);
        cd (session);
        load('rightCup.mat')
        ts_in_L{unitNum2,1}=leftCup{3};
        cd ..
        [xc, lags] = xcorr(ts_in_R{unitNum,1}, ts_in_R{unitNum2,1}, 5);
        xcMatR(unitNum, unitNum2) = max(xc);
        cd ..
    end
end
 
figure(2);hold on;
colormap('hot');
imagesc(xcMatR)
colorbar;
title('Crosscorrelation of Components_right_cup');
xlabel('Component');
ylabel('Component');
hold off;
saveas(figure(2), right_cup_xcorr)

clearvars -except session list_cells

close all
