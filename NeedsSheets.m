districts=num2str(ls);

for aa=3:length(districts)
    thisDistrict=districts(aa,1:end);
    thisDistrict=strtrim(thisDistrict);
    cd(thisDistrict)
    foldercontents=ls;
    SIZE=size(foldercontents);
    
    if SIZE(1)<3
        cd ..; cd ..
        cd('NeedsSheets')
        mkdir(thisDistrict)
        cd ..
        cd('reps_by_districtFIXED')
    else
        cd ..
    end

end