function [map]=splitMaps(Split,R,vel)

        [hab_immobile,hab_spkx_mo,hab_spky_mo,hab_ts_mo] = filt_by_speed(Split.hab.posx,Split.hab.posy,Split.hab.post,Split.hab.spkx,Split.hab.spky,Split.hab.spkt,vel);
        [map.hab,pospdf] = ratemap(hab_spkx_mo,hab_spky_mo,Split.hab.posx,Split.hab.posy,Split.hab.post,R.p.smoothing,R.mapAxis,R.mapAxis);
        
        map.hab(R.visited==0) = NaN;
        
        [cups_immobile,cups_spkx_mo,cups_spky_mo,cups_ts_mo] = filt_by_speed(Split.cups.posx,Split.cups.posy,Split.cups.post,Split.cups.spkx,Split.cups.spky,Split.cups.spkt,vel);
        [map.cups,pospdf] = ratemap(cups_spkx_mo,cups_spky_mo,Split.cups.posx,Split.cups.posy,Split.cups.post,R.p.smoothing,R.mapAxis,R.mapAxis);
        
        map.cups(R.visited==0) = NaN;
        
        [fam1_immobile,fam1_spkx_mo,fam1_spky_mo,fam1_ts_mo] = filt_by_speed(Split.fam1.posx,Split.fam1.posy,Split.fam1.post,Split.fam1.spkx,Split.fam1.spky,Split.fam1.spkt,vel);
        [map.fam1,pospdf] = ratemap(fam1_spkx_mo,fam1_spky_mo,Split.fam1.posx,Split.fam1.posy,Split.fam1.post,R.p.smoothing,R.mapAxis,R.mapAxis);
        
        map.fam1(R.visited==0) = NaN;
        
        [nov_immobile,nov_spkx_mo,nov_spky_mo,nov_ts_mo] = filt_by_speed(Split.nov.posx,Split.nov.posy,Split.nov.post,Split.nov.spkx,Split.nov.spky,Split.nov.spkt,vel);
        [map.nov,pospdf] = ratemap(nov_spkx_mo,nov_spky_mo,Split.nov.posx,Split.nov.posy,Split.nov.post,R.p.smoothing,R.mapAxis,R.mapAxis);
        
        map.nov(R.visited==0) = NaN;
        
        [fam2_immobile,fam2_spkx_mo,fam2_spky_mo,fam2_ts_mo] = filt_by_speed(Split.fam2.posx,Split.fam2.posy,Split.fam2.post,Split.fam2.spkx,Split.fam2.spky,Split.fam2.spkt,vel);
        [map.fam2,pospdf] = ratemap(fam2_spkx_mo,fam2_spky_mo,Split.fam2.posx,Split.fam2.posy,Split.fam2.post,R.p.smoothing,R.mapAxis,R.mapAxis);
        
        map.fam2(R.visited==0) = NaN;
%         
%         [nov2_immobile,nov2_spkx_mo,nov2_spky_mo,nov2_ts_mo] = filt_by_speed(Split.nov2.posx,Split.nov2.posy,Split.nov2.post,Split.nov2.spkx,Split.nov2.spky,Split.nov2.spkt,vel);
%         [map.nov2,pospdf] = ratemap(nov2_spkx_mo,nov2_spky_mo,Split.nov2.posx,Split.nov2.posy,Split.nov2.post,R.p.smoothing,R.mapAxis,R.mapAxis);
%         
        map.nov2(R.visited==0) = NaN;
        
        