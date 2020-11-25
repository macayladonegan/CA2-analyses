% % Load saved figures
% c=hgload('MyFirstFigure.fig');
% k=hgload('MySecondFigure.fig');
% % Prepare subplots
% figure
% h(1)=subplot(1,2,1);
% h(2)=subplot(1,2,2);
% % Paste figures on the subplots
% copyobj(allchild(get(c,'CurrentAxes')),h(1));
% copyobj(allchild(get(k,'CurrentAxes')),h(2));
% % Add legends
% l(1)=legend(h(1),'LegendForFirstFigure')
% l(2)=legend(h(2),'LegendForSecondFigure')

list_cells=num2str(ls('C:\Users\macayla\Desktop\Macayla_CA2\Amigo3_3chamber\TT*unit*'));

for i=1:length(list_cells)
    thisCell=list_cells(i,1:8);
    cd(thisCell)
    thisFile=strcat(thisCell,'spk_maps.fig');

    hgload(thisFile);
    title(thisCell)


    cd ..
    
end