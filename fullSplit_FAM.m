function fullSplit_FAM(tetrode,unit,posx,posy,post,spkx,spky,ts,timeStamps,mapAxis,p,visited,velThresh)
%runs makeDir, splitSessions, splitChambers, to make excel sheets for each
%cell with numSpks, times, poses, and rates for each session and chamber
%cd(session)

% cd(sess)

tetrode=num2str(tetrode);
tetrode=strcat('TT',tetrode);
unit=num2str(unit);
unit=strcat('unit',unit);
Tetrodecell=strcat(tetrode,unit);

mkdir(Tetrodecell);

cd(Tetrodecell);

splitSessions_hab

mkdir('hab')
cd('hab')
makePlots(Split.hab.posx, Split.hab.posy, Split.hab.post, Split.hab.spkx, Split.hab.spky, Split.hab.spkt, mapAxis,p,visited, velThresh)
%splitChambers(Split.hab.posx,Split.hab.posy,Split.hab.post,Split.hab.spkx,Split.hab.spky,Split.hab.spkt,tetrode,unit)
%findIntTimes(hab_posx,hab_posy,hab_post,hab_spk_posx,hab_spk_posy,hab_spk_post)
cd ..

mkdir('cups')
cd('cups')
makePlots(Split.cups.posx, Split.cups.posy, Split.cups.post, Split.cups.spkx, Split.cups.spky,  Split.cups.spkt,mapAxis,p,visited, velThresh)
%splitChambers(Split.cups.posx,Split.cups.posy,Split.cups.post,Split.cups.spkx,Split.cups.spky,Split.cups.spkt,tetrode,unit)
%findIntTimes(cups_posx,cups_posy,cups_post,cups_spk_posx,cups_spk_posy,cups_spk_post)
cd ..

mkdir('fam1')
cd('fam1')
makePlots(Split.fam1.posx, Split.fam1.posy, Split.fam1.post, Split.fam1.spkx, Split.fam1.spky, Split.fam1.spkt,mapAxis,p,visited, velThresh)
%splitChambers(Split.fam1.posx,Split.fam1.posy,Split.fam1.post,Split.fam1.spkx,Split.fam1.spky,Split.fam1.spkt,tetrode,unit)
%findIntTimes(fam1_posx,fam1_posy,fam1_post,fam1_spk_posx,fam1_spk_posy,fam1_spk_post)
cd ..

mkdir('fam2')
cd('fam2')
makePlots(Split.fam2.posx, Split.fam2.posy, Split.fam2.post, Split.fam2.spkx, Split.fam2.spky, Split.fam2.spkt, mapAxis,p,visited, velThresh)
%splitChambers(Split.fam2.posx,Split.fam2.posy,Split.fam2.post,Split.fam2.spkx,Split.fam2.spky,Split.fam2.spkt,tetrode,unit)
%findIntTimes(fam2_posx,fam2_posy,fam2_post,fam2_spk_posx,fam2_spk_posy,fam2_spk_post)
cd ..
 


close all