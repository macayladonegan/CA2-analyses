    
function makeImPlots(posx, posy, post, spkx, spky, spkt, mapAxis, p, visited, velThresh)


 %[spkx,spky] = spikePos(ts,posx,posy,post,post);
    figure(1)
%         subplot(2,1,2)
    %make heatmaps
        set(gcf,'color',[1 1 1]);
        axis square
        drawnow;
        
    %define mapaxis
        [spkx_mo,spky_mo,~] = findImmobile(posx,posy,post,spkx,spky,spkt,velThresh);
        [map,pospdf] = ratemap(spkx_mo,spky_mo,posx,posy,post,p.smoothing,mapAxis,mapAxis);
        
        map(visited==0) = NaN;
        save('map','map')
        
        if p.plotratemap == 1
        drawfield(map,mapAxis,'jet',max(max(map)),p.binWidth,p.smoothing); %colorbar
       
        else
        surfc(map);
         
        end
        
        set(gcf,'color',[1 1 1]);
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);
       
        saveas(figure(1), 'heatMap')
        figure(2)
        %make spikeplots
%     subplot(2,1,1)
        plot(posx,posy,'color',[0.5,0.5,0.5]);
        hold on
        plot(spkx_mo,spky_mo,'.k')
        hold off
                hold off
        axis image;
        axis off;
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);
    saveas(figure(2),'spkMap') 
    
        % Calculate field properties
        [nFields,fieldProp] = placefield(map,p,mapAxis);
        peakRate = nanmax(nanmax(map));
        [information,sparseness,selectivity] = mapstat(map,pospdf);
        
        fieldStats={nFields peakRate information sparseness selectivity};
        fieldStats=cell2mat(fieldStats);
        save('fieldStats', 'fieldStats')
        
        if nFields>0
            fieldProp=struct2cell(fieldProp);
            save('fieldProp', 'fieldProp')
        end
        