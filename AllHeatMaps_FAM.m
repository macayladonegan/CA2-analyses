
load Split.mat
vel=velThresh;
figure(1)
subplot(2,4,1)

        set(gcf,'color',[1 1 1]);
        axis square
        drawnow;
        
    %define mapaxis
        
        [hab_immobile,hab_spkx_mo,hab_spky_mo,hab_ts_mo] = filt_by_speed(Split.hab.posx,Split.hab.posy,Split.hab.post,Split.hab.spkx,Split.hab.spky,Split.hab.spkt,vel);
        [map,pospdf] = ratemap(hab_spkx_mo,hab_spky_mo,Split.hab.posx,Split.hab.posy,Split.hab.post,R.p.smoothing,R.mapAxis,R.mapAxis);
        [nFields.hab,fieldProp.hab] = placefield(map,R.p,R.mapAxis);
        map(R.visited==0) = NaN;
        
        if R.p.plotratemap == 1
        drawfield(map,R.mapAxis,'jet',max(max(map)),R.p.binWidth,R.p.smoothing);
       
        else
        surfc(map);
         
        end
        
        set(gcf,'color',[1 1 1]);
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);
        
        save('map.mat','map')

subplot(2,4,2)

        set(gcf,'color',[1 1 1]);
        axis square
        drawnow;
        
    %define mapaxis
        [cups_immobile,cups_spkx_mo,cups_spky_mo,cups_ts_mo] = filt_by_speed(Split.cups.posx,Split.cups.posy,Split.cups.post,Split.cups.spkx,Split.cups.spky,Split.cups.spkt,vel);
        [map,pospdf] = ratemap(cups_spkx_mo,cups_spky_mo,Split.cups.posx,Split.cups.posy,Split.cups.post,R.p.smoothing,R.mapAxis,R.mapAxis);
        [nFields.cups,fieldProp.cups] = placefield(map,R.p,R.mapAxis);
        map(R.visited==0) = NaN;
        
        if R.p.plotratemap == 1
        drawfield(map,R.mapAxis,'jet',max(max(map)),R.p.binWidth,R.p.smoothing);
       
        else
        surfc(map);
         
        end
        
        set(gcf,'color',[1 1 1]);
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);
        save('map.mat','map')

subplot(2,4,3)

        set(gcf,'color',[1 1 1]);
        axis square
        drawnow;
        
    %define mapaxis
        [fam1_immobile,fam1_spkx_mo,fam1_spky_mo,fam1_ts_mo] = filt_by_speed(Split.fam1.posx,Split.fam1.posy,Split.fam1.post,Split.fam1.spkx,Split.fam1.spky,Split.fam1.spkt,vel);
        [map,pospdf] = ratemap(fam1_spkx_mo,fam1_spky_mo,Split.fam1.posx,Split.fam1.posy,Split.fam1.post,R.p.smoothing,R.mapAxis,R.mapAxis);
        [nFields.fam1,fieldProp.fam1] = placefield(map,R.p,R.mapAxis);
        map(R.visited==0) = NaN;
        
        if R.p.plotratemap == 1
        drawfield(map,R.mapAxis,'jet',max(max(map)),R.p.binWidth,R.p.smoothing);
       
        else
        surfc(map);
         
        end
        
        set(gcf,'color',[1 1 1]);
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);
        save('map.mat','map')


subplot(2,4,4)


        set(gcf,'color',[1 1 1]);
        axis square
        drawnow;
        
    %define mapaxis
        [nov_immobile,nov_spkx_mo,nov_spky_mo,nov_ts_mo] = filt_by_speed(Split.nov.posx,Split.nov.posy,Split.nov.post,Split.nov.spkx,Split.nov.spky,Split.nov.spkt,vel);
        [map,pospdf] = ratemap(nov_spkx_mo,nov_spky_mo,Split.nov.posx,Split.nov.posy,Split.nov.post,R.p.smoothing,R.mapAxis,R.mapAxis);
        [nFields.fam2,fieldProp.fam2] = placefield(map,R.p,R.mapAxis);
        map(R.visited==0) = NaN;
        
        if R.p.plotratemap == 1
        drawfield(map,R.mapAxis,'jet',max(max(map)),R.p.binWidth,R.p.smoothing);
       
        else
        surfc(map);
         
        end
        
        set(gcf,'color',[1 1 1]);
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);
        save('map.mat','map')
        save('nFields','nFields')
        save('fieldProp','fieldProp')


subplot(2,4,5)
        plot((Split.hab.posx),(Split.hab.posy),'color',[0.5,0.5,0.5]);
        hold on
        plot(Split.hab.spkx,Split.hab.spky,'.r')
        plot(hab_spkx_mo,hab_spky_mo, '.r')
        set(gcf, 'renderer', 'opengl')
        hold off
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);

subplot(2,4,6)
        plot((Split.cups.posx),(Split.cups.posy),'color',[0.5,0.5,0.5]);
        hold on
        plot(Split.cups.spkx,Split.cups.spky,'.r')
        plot(cups_spkx_mo,cups_spky_mo, '.r')
        hold off
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);

subplot(2,4,7)
        plot((Split.fam1.posx),(Split.fam1.posy),'color',[0.5,0.5,0.5]);
        hold on
        plot(Split.fam1.spkx,Split.fam1.spky,'.r')
        plot(fam1_spkx_mo,fam1_spky_mo, '.r')
        hold off
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);


subplot(2,4,8)
        plot((Split.nov.posx),(Split.nov.posy),'color',[0.5,0.5,0.5]);
        hold on
        plot(Split.nov.spkx,Split.nov.spky,'.r')
        plot(nov_spkx_mo,nov_spky_mo, '.r')
        hold off
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);
        

filename2=strcat('Unit',num2str(i));
saveas(figure(1),filename2)

cd ..
close all