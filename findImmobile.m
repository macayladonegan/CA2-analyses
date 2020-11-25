
 function [spkx_immobile,spky_immobile,ts_immobile]=findImmobile(posx,posy,post,spkx,spky,ts,vel)
    speed = velocity(posx,posy,post);
    
    immobile=find(speed<vel);
    
    x_immobile=posx(immobile);
    y_immobile=posy(immobile);
    t_immobile=post(immobile);
    
    spkx_immobile_ind=ismember(spkx,x_immobile);
    spky_immobile_ind=ismember(spky,y_immobile);
    spkx_immobile=spkx(spkx_immobile_ind==1);
    spky_immobile=spky(spkx_immobile_ind==1);
    ts_immobile=ts(spkx_immobile_ind==1);

        
        