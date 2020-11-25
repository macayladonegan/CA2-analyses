districts=num2str(ls);

for aa=3:length(districts)
    thisDistrict=districts(aa,1:end);
    thisDistrict=strtrim(thisDistrict);
    cd(thisDistrict);cd('PDF')
    folderContents=num2str(ls);
    folderName=pwd;
    fileName(aa)=strcat(folderName,folderContents);
    cd ..; cd ..
end

xlswrite('files',fileName)