
%find your cells
list_cells=num2str(ls('C:\Users\macayla\Desktop\Macayla_CA2\Df2_3chamber'));
%define which session you want ie: cups, hab, etc
%session=('hab');

%This will break if a tetrode has more than 10 cells!
%Only use for SpikeRates, numSpikes, and Time
A=zeros(length(list_cells),4);
for i= 1:length(list_cells)
    thisCell=list_cells(i,1:8);
    cd(thisCell);
    %cd (session);
    thisFile=strcat(thisCell,'avgRate.mat');
    %readFile=read(thisFile);
    A(i,1:4)=thisFile;
    cd ..
    cd ..
end


    xlfilename=strcat(session,'avgRate.xlsx');
    xlswrite(avgRate, A)
    clear