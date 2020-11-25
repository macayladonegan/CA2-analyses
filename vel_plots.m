function []=vel_plots(posx,posy,post,spkx,spky)
    speed = speed2D(posx,posy,post);
    
    immobile=find(speed<2);
    
    x_immobile=posx(immobile);
    y_immobile=posy(immobile);
    t_immobile=post(immobile);
    
    spkx_immobile_ind=ismember(spkx,x_immobile);
    spky_immobile_ind=ismember(spky,y_immobile);
    spkx_mobile=spkx(spkx_immobile_ind==0);
    spky_mobile=spky(spky_immobile_ind==0);
    
    figure()
    plot(posx,posy,'k')
    hold on
    scatter(posx,posy,20,log(speed),'filled')
    colorbar
    hold on
    scatter(spkx,spky,30,'w','filled')
    axis image;
    axis off;
    
    save(figure(),'velocity_plots')
    