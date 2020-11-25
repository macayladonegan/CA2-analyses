%set  eveerything up for to call psth

%initialize params
params.binsize=20;
params.fs=2000;
params.triallen=4;
params.start=1305;

list_cells=num2str(ls('TT*unit*'));
sessions={'fam1' 'novel' 'fam2'};
times=cell(length(list_cells),length(sessions));

    for j=1:length(sessions)
        thisSession=sessions{j};
        currentDir=pwd;
     	[upperPath, deepestFolder]=fileparts(currentDir);
        time_cell=csv2cell(strcat(deepestFolder,thisSession,'.csv'), 'fromfile');
            for qq=1:length(time_cell)
                for rr=1:5
                    time_cell{qq,rr}=str2double(time_cell{qq,rr});
                end
            end
        time_cell=cell2mat(time_cell);
        int_start_ind=find(time_cell(:,2)==1);
        int_end_ind=find(time_cell(:,2)==1)+1;
        Time=time_cell(:,1);
        Time=Time+params.start;
        int_start=Time(int_start_ind);
        int_end=Time(int_end_ind);
        int_Left=[int_start int_end];
        
        ntrials=length(int_Left);
        
        for i= 1:length(list_cells)
            thisCell=list_cells(i,1:8);
            cd(thisCell);
            load('spkpos.mat')
            int_Spikes=strcat(thisSession,'_spk_post');
            int_Spikes=eval(int_Spikes);
            clearvars -except params int_Left int_Spikes
            int_SpikesL=cell(1,length(int_Left));
            for zz=1:length(int_Left)
                int_SpikesL{1,zz}=find(int_Spikes>(int_Left(zz,1)-params.triallen)&int_Spikes<(int_Left(zz,1)+params.triallen));
                int_SpikesL{1,zz}=int_Spikes(int_SpikesL{1,zz});
                int_SpikesL{1,zz}=int_SpikesL{1,zz}-int_SpikesL{1,zz}(1,1);
                [max_size, max_index] = max(cellfun('size', int_SpikesL, 1));
                subplot(length(int_Left),1,zz)
                histogram(int_SpikesL{1,zz},'BinWidth',1)
                ylim([0 max_size])
                hold on
            end
          
            
            cd ..
        
        end
end



save figure() PSTH_ints