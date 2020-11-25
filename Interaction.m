list_cells=num2str(ls('TT*unit*'));

sessions={'hab', 'cups', 'fam1', 'novel', 'fam2'};

spikes_leftcup={length(list_cells),length(sessions)};
for i= 1:length(list_cells)
    thisCell=list_cells(i,1:8);
    cd(thisCell);
    for j=1:length(sessions)
        thisSession=sessions{j};
        cd(thisSession)
        load('leftcup.mat')
        intSpikes=leftCup{7};
        spikes_leftcup{i,j}=intSpikes;
        cd ..
    end   
    cd ..
end


    cd(list_cells(1,1:8));
    time_leftcup=ones(1,length(sessions));
    for j=1:length(sessions)
        thisSession=sessions{j};
        cd(thisSession)
        load('leftcup.mat')
        time=length(leftCup{4});
        time_leftcup(j)=time;
        cd ..
        
    end 
    cd ..



spikes_rightcup={length(list_cells),length(sessions)};
for i= 1:length(list_cells)
    thisCell=list_cells(i,1:8);
    cd(thisCell);
    for j=1:length(sessions)
        thisSession=sessions{j};
        cd(thisSession)
        load('rightcup.mat')
        intSpikes=rightCup{7};
        spikes_rightcup{i,j}=intSpikes;
        cd ..
    end   
    cd ..
end


time_rightcup=ones(1,length(sessions));

    cd(list_cells(1,1:8));
    for j=1:length(sessions)
        thisSession=sessions{j};
        cd(thisSession)
        load('rightcup.mat')
        time=length(rightCup{4});
        time_rightcup(j)=time;
        cd ..
    end   
    cd ..


currentDir=pwd;
[upperPath, deepestFolder]=fileparts(currentDir);
spikeL_name=strcat(deepestFolder,'LC_spikes.xlsx');
xlswrite(spikeL_name, spikes_leftcup)

spikeR_name=strcat(deepestFolder,'RC_spikes.xlsx');
xlswrite(spikeR_name, spikes_rightcup)

timeL_name=strcat(deepestFolder,'LC_time.xlsx');
xlswrite(timeL_name, time_leftcup)

timeR_name=strcat(deepestFolder,'RC_time.xlsx');
xlswrite(timeR_name, time_rightcup)