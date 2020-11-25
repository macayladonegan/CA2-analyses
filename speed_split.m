load one_minBins.mat
list_cells=num2str(ls('TT*unit*'));
for ii=1:length(list_cells)
    thisCell=list_cells(ii,1:8);
    cd(thisCell);
    
    load spks.mat
    speed = speed2D(posx,posy,post);
    clearvars -except speed posx posy post list_cells one_minBins
    
    post_split=cell(size(one_minBins));
   
    
    for j=1:5
        for i=1:9
            post_split{j,i}=find(post>one_minBins(j,i)& post<one_minBins(j,i+1));  
        end
    end
    
    speed_splits=cell(size(one_minBins));
    
    for q=1:5
        for r=1:9
            speed_splits{q,r}=find(post>one_minBins(q,r)& post<one_minBins(q,r+1));
            
        end
    end
    save('speedpermin')
    cd ..
end