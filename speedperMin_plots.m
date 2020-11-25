list_cells=num2str(ls('TT*unit*'));


hab_speed=ones(length(list_cells), 9);
cup_speed=ones(length(list_cells), 9);
fam1_speed=ones(length(list_cells), 9);
nov_speed=ones(length(list_cells), 9);
fam2_speed=ones(length(list_cells), 9);
for j=1:length(list_cells)
        thisCell=list_cells(j,1:8);
        cd(thisCell);

        load speedpermin.mat
        
        
        hab_speed_split=ones(1,9);
        cup_speed_split=ones(1,9);
        fam1_speed_split=ones(1,9);
        nov_speed_split=ones(1,9);
        fam2_speed_split=ones(1,9);
        for i=1:9
            hab_speed_split(i)=length(speed_splits{1,i});
            cup_speed_split(i)=length(speed_splits{2,i});
            fam1_speed_split(i)=length(speed_splits{3,i});
            nov_speed_split(i)=length(speed_splits{4,i});
            fam2_speed_split(i)=length(speed_splits{5,i});
        end
        all_speed_split=vertcat(hab_speed_split,cup_speed_split,fam1_speed_split,nov_speed_split,fam2_speed_split);
        save('all_speed_split','all_speed_split')
        
        max_all=max(all_speed_split);
        
        ax=round(max(max_all))+10;
        
        hab_speed(j,1:9)=hab_speed_split;
        cup_speed(j,1:9)=cup_speed_split;
        fam1_speed(j,1:9)=fam1_speed_split;
        nov_speed(j,1:9)=nov_speed_split;
        fam2_speed(j,1:9)=hab_speed_split;
      
        
        cd ..

end

for ii=1:length(list_cells)
        subplot(1,5,1)
        stairs(mean(hab_speed),'k','linewidth',2)
        title('hab')
        
        subplot(1,5,2)
        stairs(mean(cup_speed),'k','linewidth',2)
        title('cups')
        
        subplot(1,5,3)
        stairs(mean(fam1_speed),'k','linewidth',2)
        title('fam1')
        
        subplot(1,5,4)
        stairs(mean(nov_speed),'k','linewidth',2)
        title('nov')
        
        subplot(1,5,5)
        stairs(mean(fam2_speed),'k','linewidth',2)
        title('fam2')
        

end
saveas(figure(1),'spksPerMin')