figure
barwitherr([std(FR(:,1))/sqrt(size(FR,1));std(FR(:,2))/sqrt(size(FR,1));std(FR(:,3))/sqrt(size(FR,1));...
    std(FR(:,4))/sqrt(size(FR,1));std(FR(:,5))/sqrt(size(FR,1))],...
    [mean(FR(:,1));mean(FR(:,2));mean(FR(:,3));mean(FR(:,4));mean(FR(:,5))]);

%Figure1 a) rigth
figure
for i =1:ntotal
    hold on;
    plot(FR(i,:),'-mo','color',rand(1,3));
end
clear i

%Figure1 b) left
figure
bar([mean((FRz(:,1)));mean((FRz(:,2)));mean((FRz(:,3)));mean((FRz(:,4)));mean((FRz(:,5)))]);



%Figure1 b) right
%find preferred stage for cells firing
for i=1:ntotal
    if FRz_all(i,:)==0
        preferred_stage(i)=NaN;
    else
        preferred_stage(i) = find(FRz_all(i,:)==max(FRz_all(i,:)));
    end
end
clear i
%count proportion
for i =1:5
    preferred(i) = length(find(preferred_stage==i))/size(preferred_stage,2);
end
clear i

figure
bar(preferred);


%Figure1 c) left = box plots
figure
boxplot(FRz(:,2));ylim([-2 2]);
figure
boxplot(FRz(:,1));ylim([-2 2]);
figure
boxplot(FRz(:,4));ylim([-3 5]);
figure
boxplot(mean([FRz(:,3),FRz(:,3)],2));ylim([-3 5]);
figure
boxplot([-0.2368,0.2954,0.2458,-0.9874,-0.3515,1.3969,-0.7086,1.3100,1.3911,-0.0624,0.1281,-0.4843,-1.0588,-0.2860,-0.6562,-0.9615]);ylim([-3 5]);
%Figure1 c) right = ratio plots

order = [];
temp = find(preferred_stage==4); %cause I see this as a main group
order = cat(2,order,temp);clear temp
temp = find(preferred_stage==2); %cause I see this as a main group also
order = cat(2,order,temp);clear temp
temp = find(preferred_stage==3); %cause I see this as a main group
order = cat(2,order,temp);clear temp
temp = find(preferred_stage==1); %cause I see this as a main group
order = cat(2,order,temp);clear temp
temp = find(preferred_stage==5); %cause I see this as a main group
order = cat(2,order,temp);clear temp
% temp = find(preferred_stage==6); %cause I see this as a main group
% order = cat(2,order,temp);clear temp

figure
for i =1:ntotal
    subplot(ntotal,1,i);
    bar(FRz(order(i),:));
    ylim([-2 2]);
    set(gca,'visible','off');
end
clear i

%FR reorder following preferred stage of firing
for i =1:ntotal
    FRz_reorder(i,:)=FRz(order(i),:);
    FR_reorder(i,:)=FR(order(i),:);
end
clear i

figure
imagesc(FRz_reorder);
colorbar
%With FR without normalizing you dont see anything!
% figure
% imagesc(FR_reorder);


hierarchical organization analysis based on FR (raw)
%Figure 2 a)
%correlations - intra sessions correlation dont make sense this way...
for i =1:size(FR,2)
    for j =1:size(FR,2)
        if i==j
            rho(i,j) = corr(FR(1:length(FR)/2,i),FR(length(FR)/2+1:end,j));
            rho_z(i,j) = corr(zscore(FR(1:length(FR)/2,i)),zscore(FR(length(FR)/2+1:end,j)));
        else
            rho(i,j) = corr(FR(:,i),FR(:,j));
            rho_z(i,j) = corr(zscore(FR(:,i)),zscore(FR(:,j)));
        end
        %         rho() = corr(FR(1:length(FR)/2,2),FR(length(FR)/2+1:end,1));
        %         %empty environment vs empty environment with novel object+familiar mouse
        %         rho(3,3) = corr(FR(1:length(FR)/2,3),FR(length(FR)/2+1:end,1));
        %         %empty environment vs empty environment with novel object+familiar mouse
        %         rho(4,4) = corr(FR(1:length(FR)/2,4),FR(length(FR)/2+1:end,1));
        %         %empty environment vs empty environment with novel object+familiar mouse
        %         rho(5,5) = corr(FR(1:length(FR)/2,5),FR(length(FR)/2+1:end,1));
    end
end


%this doesn't give any info this way... maybe half of the time agains the
%other half?
rho_within = cat(1,rho(1,1),rho(2,2),rho(3,3),rho(4,4),rho(5,5));
%rho_within_z = cat(1,rho_z(1,1),rho_z(2,2),rho_z(3,3),rho_z(4,4),rho_z(5,5));

%just correlative following the task... = not sure if they want this
%interpretation..
rho_between = cat(1,rho(1,2),rho(2,3),rho(3,4),rho(4,5));
rho_between_2 = cat(1,rho(1,2),rho(2,3),rho(2,4),rho(3,5));


%this is OK
rho_space = rho_z(3,5);
rho_conspecific_familiar = mean([rho_z(2,3),rho_z(2,5)]);
rho_conspecific_novel = rho_z(2,4);
%rho_conspecific_novelanimal = rho_z(4,6);
rho_conspecific_familiaranimal = rho_z(4,5);
figure
bar([rho_space,rho_conspecific_familiar,rho_conspecific_novel ...
    rho_conspecific_familiaranimal]);

figure
bar(rho_within);
figure
bar(rho_between);
figure
bar(rho_between_2);


%% hierarchical organization of population vectors...
%condition 1 = context (alocentric space)
%condition 2 = context (alocentric space) + object (novel)
%condition 3 = context (alocentric space) + object + familiar mouse(position1) novelty?
%condition 4 = context (alocentric space) + object + novel mouse (position1) novelty?
%condition 5 = context (alocentric space) + object + familiar mouse (position2) novelty?
%condition 6 = context (alocentric space) + object + novel mouse (position2) novelty?

habituation_rho = rho(1,1);
object_rho = mean([rho(1,2),rho(1,3),rho(1,4),rho(1,5)]);
familiar_rho = mean([rho(1,3),rho(1,5),rho(2,3),rho(2,5)]);
novel_rho = mean([rho(1,4),rho(2,4),rho(3,4),rho(5,4)]);
position_rho = mean([rho(1,3),rho(1,5)]);

%dendrogram
var2cluster = FRz(:,2:5)';
Z = linkage(var2cluster,'ward','euclidean');
figure
dendrogram(Z)

Z = linkage(var2cluster,'average','correlation');
figure
dendrogram(Z)


figure
c = cluster(Z,'maxclust',4);
scatter3(var2cluster(:,1),var2cluster(:,2),var2cluster(:,3),10,c);