list_cells=num2str(ls('TT*unit*'));
sessions={'hab', 'cups', 'fam1', 'nov', 'fam2'};

field_size=ones(length(list_cells),length(sessions));
    for ii=1:length(list_cells)
       thisCell=list_cells(ii,1:9);
       cd(thisCell)
       load('spkpos.mat')
       
       
        [map,pospdf] = ratemap(hab_spk_posx,hab_spk_posy,hab_posx,hab_posy,hab_post,p.smoothing,mapAxis,mapAxis);
        map(visited==0) = NaN;
        [nFields,fieldProp] = placefield(map,p,mapAxis);
        if nFields~=0
        field_size(ii,1)=fieldProp.size;
        end
        
         
        [map,pospdf] = ratemap(cups_spk_posx,cups_spk_posy,cups_posx,cups_posy,cups_post,p.smoothing,mapAxis,mapAxis);
        map(visited==0) = NaN;
        [nFields,fieldProp] = placefield(map,p,mapAxis);
        if nFields~=0
        field_size(ii,2)=fieldProp.size;
        end
        
        [map,pospdf] = ratemap(fam1_spk_posx,fam1_spk_posy,fam1_posx,fam1_posy,fam1_post,p.smoothing,mapAxis,mapAxis);
        [nFields,fieldProp] = placefield(map,p,mapAxis);
        if nFields~=0
        field_size(ii,3)=fieldProp.size;
        end
         
        [map,pospdf] = ratemap(nov_spk_posx,nov_spk_posy,novel_posx,novel_posy,novel_post,p.smoothing,mapAxis,mapAxis);
        map(visited==0) = NaN;
        [nFields,fieldProp] = placefield(map,p,mapAxis);
        if nFields~=0
        field_size(ii,4)=fieldProp.size;
        end
        
        [map,pospdf] = ratemap(fam2_spk_posx,fam2_spk_posy,fam2_posx,fam2_posy,fam2_post,p.smoothing,mapAxis,mapAxis);
        map(visited==0) = NaN;
        [nFields,fieldProp] = placefield(map,p,mapAxis);
        if nFields~=0
        field_size(ii,5)=fieldProp.size;
        end
      
      
       cd ..
    end
    
    save('fieldSize','field_size')