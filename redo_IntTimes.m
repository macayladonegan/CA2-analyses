
list_cells=num2str(ls('TT*unit*'));

for i= 1:length(list_cells)
    
    thisCell=list_cells(i,1:9);
    cd(thisCell);
    load ('spkpos.mat')
    cd('hab')
        findIntTimes(hab_posx,hab_posy,hab_post,hab_spk_posx,hab_spk_posy,hab_spk_post)
        cd ..
    cd('cups')
        findIntTimes(cups_posx,cups_posy,cups_post,cups_spk_posx,cups_spk_posy,cups_spk_post)
        cd ..
    cd('fam1')
        findIntTimes(fam1_posx,fam1_posy,fam1_post,fam1_spk_posx,fam1_spk_posy,fam1_spk_post)
        cd ..
    cd('novel')
        findIntTimes(novel_posx,novel_posy,novel_post,nov_spk_posx,nov_spk_posy,nov_spk_post)
        cd ..
    cd('fam2')
        findIntTimes(fam2_posx,fam2_posy,fam2_post,fam2_spk_posx,fam2_spk_posy,fam2_spk_post)
        
        cd ..
        cd ..
end

clear 
close all
