for hh=1:yy(1)
    cd(animalIDs(hh,1:end))
list_cells=num2str(ls('TT*unit*'));


sessions={'hab','cups','fam1', 'nov', 'fam2'};
    for j=1:length(list_cells)
        cd(list_cells(j,1:end))
        load('Split')
        for k=1:length(sessions)
        thisSession=sessions(k);
        thisSession=cellstr(thisSession); 
        thisSession=char(thisSession);
        cd(thisSession)
        post=eval(strcat('Split.',thisSession,'.post'));
        spkt=eval(strcat('Split.',thisSession,'.spkt'));
        load('rightCup.mat');
        load('leftCup.mat');
        if isempty(rightCup{4})
            In(j,k)=0;
        else
            In(j,k)=rightCup{7}/length(rightCup{4});
        end
        Out(j,k)=(length(spkt)-leftCup{7}-In(j,k))/(length(post)-length(rightCup{4})-length(leftCup{4}));
        I_V_O(j,k)=In(j,k)-Out(j,k);
        cd ..
        end
        cd ..
        InvsOut{hh}=I_V_O;
        
    end
    clearvars('I_V_O', 'In','Out')
    cd ..
end
