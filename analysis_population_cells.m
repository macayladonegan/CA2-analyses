load(['E:\data\macayla\average\single_cells\matlab_1']);

%% hierarchical organization analysis based on FR (raw)
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

figure
bar([rho_space,rho_conspecific_familiar,rho_conspecific_novel]);

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