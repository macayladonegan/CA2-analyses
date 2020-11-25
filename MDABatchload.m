myFiles=ls('Df*');

for ii=1:length(myFiles)
    thisFile=myFiles(ii,1:end);
    cd(thisFile)
    clearvars -except ii myFiles
    OE2mda
    clear memory
    cd ..
end