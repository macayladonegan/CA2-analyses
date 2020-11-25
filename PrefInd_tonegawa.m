load('cups')

list_cells=num2str(ls('TT*unit*'));
sessions={'hab', 'cups', 'fam1', 'nov', 'fam2'};

for ii=1:length(list_cells)
    thisCell=list_cells(ii,1:end);
    cd(thisCell);load('Split')
    for jj=1:length(sessions)
        thisSession=sessions(jj);
        thisSession=cellstr(thisSession);
        thisSession=char(thisSession);
        posx=eval(strcat('Split.',thisSession,'.posx'));
        posy=eval(strcat('Split.',thisSession,'.posy'));
        spkx=eval(strcat('Split.',thisSession,'.spkx'));
        spky=eval(strcat('Split.',thisSession,'.spky'));
        
        [dist_cup_l,avgDist_l]=dist_fromCup(posx,posy,spkx,spky,cups.lxc,cups.lyc);
        [dist_cup_r,avgDist_r]=dist_fromCup(posx,posy,spkx,spky,cups.rxc,cups.ryc);
        
        if isempty(spky)
        else
        for kk=1:length(dist_cup_l)
            PrefInd(kk)=(dist_cup_l(kk)-dist_cup_r(kk))/(dist_cup_l(kk)+dist_cup_r(kk));
        end
        PrefScore(ii,jj)=mean(PrefInd);
        end

    end
    cd ..
end

        %%compare with shuffled data- make 10000 imaginary neurons
        for jj=1:length(sessions)
            PrefScore_i=makedist('Normal',mean(PrefScore(:,jj)),std(PrefScore(:,jj)));
            dist(jj,:)=cdf(PrefScore_i,PrefScore(:,jj)');
            PrefScorehist(:,jj)=normrnd(mean(PrefScore(:,jj)),std(PrefScore(:,jj)),[1 10000]);
        end

        close all
        hold on

        %h1=histogram(PrefScore(:,4),30);
        h2=histogram(PrefScore(:,3),30);
        h3=histogram(PrefScore(:,5),30);
        
        %xlim([min(min(PrefScorehist)) max(max(PrefScorehist))]);
        %legend([h1 h2 h3],{'novel','fam1','fam2'})
        legend([h2 h3],{'fam1','fam2'})
        
        MEAN=mean(PrefScorehist(:,3)); yy=0:6; MEAN=repmat(MEAN,size(yy));
        l1=plot(MEAN,yy,'r');
        STD1=MEAN+std(PrefScorehist(:,3)); l2=plot(STD1,yy,'k');STD2=MEAN-std(PrefScorehist(:,3)); l4=plot(STD2,yy,'k');
        STD3=MEAN+2*std(PrefScorehist(:,3)); l3=plot(STD3,yy,'k');STD4=MEAN-2*std(PrefScorehist(:,3)); l5=plot(STD4,yy,'k');
        %STD5=MEAN+3*std(PrefScorehist(:,4)); l6=plot(STD5,yy,'k');STD6=MEAN-3*std(PrefScorehist(:,3)); l7=plot(STD6,yy,'k');

        set(get(get(l1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        set(get(get(l2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        set(get(get(l3,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        set(get(get(l4,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        set(get(get(l5,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        set(get(get(l6,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        set(get(get(l7,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        
