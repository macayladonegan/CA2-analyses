
%create_timeStamps

ts=cell2mat(ts);
for ii=1:length(timeStamps)/2
    split_ts{ii}=find(ts>timeStamps(2*ii-1)& ts<timeStamps(2*ii));
end
%find closet values in post
post{1}=post{1}+timeStamps(1);post{2}=post{2}+timeStamps(3);
post{3}=post{3}+timeStamps(5);post{4}=post{4}+timeStamps(7);


Split.hab.spkt= ts(split_ts{1});
[Split.hab.spkx,Split.hab.spky,~] = spikePos(Split.hab.spkt,posy{1},posx{1},post{1},post{1});

Split.hab.posx= posy{1};
Split.hab.posy= posx{1};
Split.hab.post= post{1};

Split.cups.spkt= ts(split_ts{2});
[Split.cups.spkx,Split.cups.spky,~] = spikePos(Split.cups.spkt,posy{2},posx{2},post{2},post{2});

Split.cups.posx= posy{2};
Split.cups.posy= posx{2};
Split.cups.post= post{2};

Split.fam1.spkt= ts(split_ts{3});
[Split.fam1.spkx,Split.fam1.spky,~] = spikePos(Split.fam1.spkt,posy{3},posx{3},post{3},post{3});

Split.fam1.posx= posy{3};
Split.fam1.posy= posx{3};
Split.fam1.post= post{3};

Split.fam2.spkt= ts(split_ts{4});
[Split.fam2.spkx,Split.fam2.spky,~] = spikePos(Split.fam2.spkt,posy{4},posx{4},post{4},post{4});

Split.fam2.posx= posy{4};
Split.fam2.posy= posx{4};
Split.fam2.post= post{4};

save('Split','Split')



