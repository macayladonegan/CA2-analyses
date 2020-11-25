list_cells=num2str(ls('TT*unit*'));


hab_ts=ones(length(list_cells), 9);
cup_ts=ones(length(list_cells), 9);
fam1_ts=ones(length(list_cells), 9);
nov_ts=ones(length(list_cells), 9);
fam2_ts=ones(length(list_cells), 9);
for j=1:length(list_cells)
        thisCell=list_cells(j,1:8);
        cd(thisCell);

        load post_split.mat
        load ts_split.mat
        
        hab_ts_split=ones(1,9);
        cup_ts_split=ones(1,9);
        fam1_ts_split=ones(1,9);
        nov_ts_split=ones(1,9);
        fam2_ts_split=ones(1,9);
        for i=1:9
            hab_ts_split(i)=length(ts_split{1,i});
            cup_ts_split(i)=length(ts_split{2,i});
            fam1_ts_split(i)=length(ts_split{3,i});
            nov_ts_split(i)=length(ts_split{4,i});
            fam2_ts_split(i)=length(ts_split{5,i});
        end
        all_ts_split=vertcat(hab_ts_split,cup_ts_split,fam1_ts_split,nov_ts_split,fam2_ts_split);
        save('all_ts_split','all_ts_split')
        
        max_all=max(all_ts_split);
        
        ax=round(max(max_all))+10;
        
        hab_ts(j,1:9)=hab_ts_split;
        cup_ts(j,1:9)=cup_ts_split;
        fam1_ts(j,1:9)=fam1_ts_split;
        nov_ts(j,1:9)=nov_ts_split;
        fam2_ts(j,1:9)=hab_ts_split;
      
        
        cd ..

end

for ii=1:length(list_cells)
        subplot(1,5,1)
        stairs(hab_ts(ii,1:9),'color',rand(1,3))
        hold on
        stairs(mean(hab_ts),'k','linewidth',2)
        title('hab')
        
        subplot(1,5,2)
        stairs(cup_ts(ii,1:9),'color',rand(1,3))
        hold on
        stairs(mean(cup_ts),'k','linewidth',2)
        title('cups')
        
        subplot(1,5,3)
        stairs(fam1_ts(ii,1:9),'color',rand(1,3))
        hold on
        stairs(mean(fam1_ts),'k','linewidth',2)
        title('fam1')
        
        subplot(1,5,4)
        stairs(nov_ts(ii,1:9),'color',rand(1,3))
        hold on
        stairs(mean(nov_ts),'k','linewidth',2)
        title('nov')
        
        subplot(1,5,5)
        stairs(fam2_ts(ii,1:9),'color',rand(1,3))
        hold on
        stairs(mean(fam2_ts),'k','linewidth',2)
        title('fam2')
        

end
saveas(figure(1),'spksPerMin')