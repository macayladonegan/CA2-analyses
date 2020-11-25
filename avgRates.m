%find your cells
list_cells=num2str(ls('C:\Users\macayla\Desktop\Macayla_CA2\Df2_3chamber\TT*unit*'));

%This will break if a tetrode has more than 10 cells!
%Only use for SpikeRates, numSpikes, and Time
A=zeros(length(list_cells),1);
for i= 1:length(list_cells)
    thisCell=list_cells(i,1:9);
    cd(thisCell);
    load spks.mat
    A(i)=peakRate;
    cd ..
end


save('avgRates.mat','A')