%make a data structure with binary (1 indicating a spike) for all spikes
%from all cells.  this data structure will be post x num_Cells.  you should
%write a seperate function for this?
% use code from makeExcel to define num cells
list_cells=num2str(ls('C:\Users\macayla\Desktop\Macayla_CA2\amigo7_3chamber2\TT*unit*'));
num_Cells=length(list_cells);
cd(list_cells(1,1:8));
load 'spks.mat'
allCells=ones(length(post), length(num_Cells));
cd ..
for k= 1:length(num_Cells)
    cd(list_cells(k,1:8))
        load 'spks.mat'
        %how to do this when ts and spkx dont line up?
        
        t=ts';
        figure(1) 
        clf
        
        subplot(1,1,1)
        plot([t;t],[ones(size(t));zeros(size(t))],'k')
        axis([0 max(t)+k -1 length(num_Cells)])
        hold on
        
        cd ..
    
end
%find interaction times

%find the location of the cup, use the code from alex

% define 2 circles around the cup, find posx's, find post's