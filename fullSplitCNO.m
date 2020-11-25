
function fullSplitCNO(tetrode,unit,posx,posy,post,spkx,spky,ts,timeStamps,mapAxis,p,visited)
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

splitSessionsCNO

% mkdir('hab')
% cd('hab')
% makePlots(Split.sleep1.posx, Split.sleep1.posy, Split.sleep1.post, Split.sleep1.spkx, Split.sleep1.spky, mapAxis,p,visited)
% cd ..
% 
% mkdir('cups')
% cd('cups')
% makePlots(Split.OF1.posx, Split.OF1.posy, Split.OF1.post, Split.OF1.spkx, Split.OF1.spky, mapAxis,p,visited)
% cd ..
% 
% mkdir('fam1')
% cd('fam1')
% makePlots(Split.sleep2.posx, Split.sleep2.posy, Split.sleep2.post, Split.sleep2.spkx, Split.sleep2.spky, mapAxis,p,visited)
% cd ..
% 
% mkdir('nov')
% cd('nov')
% makePlots(Split.OF2.posx, Split.OF2.posy, Split.OF2.post, Split.OF2.spkx, Split.OF2.spky, mapAxis,p,visited)
% cd ..


close all