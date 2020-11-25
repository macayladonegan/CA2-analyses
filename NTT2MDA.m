clear
tic
TTs=ls('TT*.ntt');
mkdir('MDAs');
for aa=1:length(TTs)
    thisTT=TTs(aa,:);
    data=read_ntt_files(thisTT);
    TTname=num2str(aa);
    cd('MDAs')
    TTdata=int32(data.waveforms);
    thisdir=strcat('MDA',TTname);mkdir(thisdir);cd(thisdir)
    mdaname=strcat('raw','.mda');
    writemda(TTdata,mdaname,'int32')
    
    %% add geom file to each folder
    g=[0,0
        -25,25
        25,25
        0,50];
    csvwrite('geom.csv',g)
    %% copy param files into each folder
    thisdir=pwd;
    copyfile C:\Users\macayla\Documents\GitHub\mountainsort_examples\examples\example1_mlp\params.json params.json
    copyfile C:\Users\macayla\Documents\GitHub\mountainsort_examples\examples\example1_mlp\mountainsort3.mlp mountainsort3.mlp
    cd ..;cd ..
    
    
end
cd ..

toc