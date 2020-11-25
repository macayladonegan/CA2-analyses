
function cellInfo(tetrode,unit,posx,posy,post,spkx,spky,spkt,mapAxis,p,visited)

tetrode=num2str(tetrode);
tetrode=strcat('TT',tetrode);
unit=num2str(unit);
unit=strcat('unit',unit);
Tetrodecell=strcat(tetrode,unit);

mkdir(Tetrodecell);

cd(Tetrodecell);
spkx=spkx{1,1};
spky=spky{1,1};
makePlots(posx, posy, post, spkx, spky,mapAxis, p, visited)