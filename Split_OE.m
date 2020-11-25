
function Split_OE(tetrode,unit,posx,posy,post,spkx,spky,ts,timeStamps,mapAxis,p,visited,velThresh)
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

splitSessions_oe

for numSess=1:length(closest)/2
    sessName=strcat('Session',num2str(numSess));
    mkdir(sessName); cd(sessName)
    makePlots(Split(numSess).posx, Split(numSess).posy, Split(numSess).post, Split(numSess).spkx, Split(numSess).spky,  Split(numSess).spkt,mapAxis,p,visited, velThresh);
    cd ..
end



cd ..

close all


