
%dir='TT2unit8';

load Split.mat

%choose your vel cut off!
vel=.5;

figure(1)
subplot(2,5,1)

        set(gcf,'color',[1 1 1]);
        axis square
        drawnow;
        
    %define mapaxis
        
        [hab_spkx_mo,hab_spky_mo,~] = findImmobile(Split.hab.posx,Split.hab.posy,Split.hab.post,Split.hab.spkx,Split.hab.spky,Split.hab.spkt,vel);
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

subplot(2,5,2)

        set(gcf,'color',[1 1 1]);
        axis square
        drawnow;
        
    %define mapaxis
        [,cups_spkx_mo,cups_spky_mo,~] = findImmobile(Split.cups.posx,Split.cups.posy,Split.cups.post,Split.cups.spkx,Split.cups.spky,Split.cups.spkt,vel);
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

subplot(2,5,3)

        set(gcf,'color',[1 1 1]);
        axis square
        drawnow;
        
    %define mapaxis
        [,fam1_spkx_mo,fam1_spky_mo,~] = findImmobile(Split.fam1.posx,Split.fam1.posy,Split.fam1.post,Split.fam1.spkx,Split.fam1.spky,Split.fam1.spkt,vel);
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

subplot(2,5,4)

        set(gcf,'color',[1 1 1]);
        axis square
        drawnow;
        
    %define mapaxis
        [,nov_spkx_mo,nov_spky_mo,~] = findImmobile(Split.nov.posx,Split.nov.posy,Split.nov.post,Split.nov.spkx,Split.nov.spky,Split.nov.spkt,vel);
        [map,pospdf] = ratemap(nov_spkx_mo,nov_spky_mo,Split.nov.posx,Split.nov.posy,Split.nov.post,R.p.smoothing,R.mapAxis,R.mapAxis);
        [nFields.nov,fieldProp.nov] = placefield(map,R.p,R.mapAxis);
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

subplot(2,5,5)


        set(gcf,'color',[1 1 1]);
        axis square
        drawnow;
        
    %define mapaxis
        [fam2_spkx_mo,fam2_spky_mo,~] = findImmobile(Split.fam2.posx,Split.fam2.posy,Split.fam2.post,Split.fam2.spkx,Split.fam2.spky,Split.fam2.spkt,vel);
        [map,pospdf] = ratemap(fam2_spkx_mo,fam2_spky_mo,Split.fam2.posx,Split.fam2.posy,Split.fam2.post,R.p.smoothing,R.mapAxis,R.mapAxis);
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

        
% subplot(2,5,5)
% 
% 
% 
%         set(gcf,'color',[1 1 1]);
%         axis square
%         drawnow;
%         
%     define mapaxis
%         [nov2_immobile,nov2_spkx_mo,nov2_spky_mo,nov2_ts_mo] = findImmobile(Split.nov2.posx,Split.nov2.posy,Split.nov2.post,Split.nov2.spkx,Split.nov2.spky,Split.nov2.spkt,vel);
%         [map,pospdf] = ratemap(nov2_spkx_mo,nov2_spky_mo,Split.nov2.posx,Split.nov2.posy,Split.nov2.post,R.p.smoothing,R.mapAxis,R.mapAxis);
%         [nFields.nov2,fieldProp.nov2] = placefield(map,R.p,R.mapAxis);
%         map(R.visited==0) = NaN;
%         
%         if R.p.plotratemap == 1
%         drawfield(map,R.mapAxis,'jet',max(max(map)),R.p.binWidth,R.p.smoothing);
%        
%         else
%         surfc(map);
%          
%         end
%         
%         set(gcf,'color',[1 1 1]);
%         axis image;
%         axis off;
%         f = getframe(gcf);
%         [pic, cmap] = frame2im(f);
%         save('map.mat','map')


subplot(2,5,6)
        plot(smooth(Split.hab.posx),smooth(Split.hab.posy),'color',[0.5,0.5,0.5]);
        hold on
        %plot(Split.hab.spkx,Split.hab.spky,'.r')
        plot(hab_spkx_mo,hab_spky_mo, '.r')
        set(gcf, 'renderer', 'opengl')
        hold off
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);

subplot(2,5,7)
        plot(smooth(Split.cups.posx),smooth(Split.cups.posy),'color',[0.5,0.5,0.5]);
        hold on
        %plot(Split.cups.spkx,Split.cups.spky,'.r')
        plot(cups_spkx_mo,cups_spky_mo, '.r')
        hold off
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);

subplot(2,5,8)
        plot(smooth(Split.fam1.posx),smooth(Split.fam1.posy),'color',[0.5,0.5,0.5]);
        hold on
        %plot(Split.fam1.spkx,Split.fam1.spky,'.r')
        plot(fam1_spkx_mo,fam1_spky_mo, '.r')
        hold off
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);

subplot(2,5,9)
        plot(smooth(Split.nov.posx),smooth(Split.nov.posy),'color',[0.5,0.5,0.5]);
        hold on
        %plot(Split.nov.spkx,Split.nov.spky,'.r')
        plot(nov_spkx_mo,nov_spky_mo, '.r')
        hold off
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);

subplot(2,5,10)
        plot(smooth(Split.fam2.posx),smooth(Split.fam2.posy),'color',[0.5,0.5,0.5]);
        hold on
        %plot(Split.fam2.spkx,Split.fam2.spky,'.r')
        plot(fam2_spkx_mo,fam2_spky_mo, '.r')
        hold off
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);
        
%         subplot(2,6,12)
%         plot(Split.nov2.posx,Split.nov2.posy,'color',[0.5,0.5,0.5]);
%         hold on
%         plot(Split.nov2.spkx,Split.nov2.spky,'.k')
%         plot(nov2_spkx_mo,nov2_spky_mo, '.r')
%         hold off
%         axis image;
%         axis off;
%         f = getframe(gcf);
%         [pic, cmap] = frame2im(f);

%filename2=strcat('TT',num2str(tetrode),'unit',num2str(unit),'spk_maps');
%saveas(figure(1),filename2)

%cd ..
%close all