function mapAxis = setMapAxis(posx,posy,mapAxis,binWidth)

% Check for asymmetri in the path. If so correct acount for it in
% mapAxis
minX = min(posx);
maxX = max(posx);
minY = min(posy);
maxY = max(posy);
if minX < mapAxis(1)
    nXtra = ceil(abs(minX-mapAxis(1))/binWidth);
else
    nXtra = 0;
end
if maxX > mapAxis(end)
    pXtra = ceil(abs(maxX-mapAxis(end))/binWidth);
else
    pXtra = 0;
end
if nXtra
    for nn =1:nXtra
        tmp = mapAxis(1) - binWidth;
        mapAxis = [tmp; mapAxis'];
        mapAxis = mapAxis';
    end
end
if pXtra
    tmp = mapAxis(end) + binWidth;
    mapAxis = [mapAxis'; tmp];
    mapAxis = mapAxis';
end

if minY < mapAxis(1)
    nXtra = ceil(abs(minX-mapAxis(1))/binWidth);
else
    nXtra = 0;
end
if maxY > mapAxis(end)
    pXtra = ceil(abs(maxX-mapAxis(end))/binWidth);
else
    pXtra = 0;
end
if nXtra
    for nn =1:nXtra
        tmp = mapAxis(1) - binWidth;
        mapAxis = [tmp; mapAxis'];
        mapAxis = mapAxis';
    end
end
if pXtra
    tmp = mapAxis(end) + binWidth;
    mapAxis = [mapAxis'; tmp];
    mapAxis = mapAxis';
end

% Put on 3 extra cm on each side.
mapAxis = [mapAxis(1)-1.5;mapAxis'];
mapAxis = [mapAxis; mapAxis(end)+1.5];
mapAxis = mapAxis';
mapAxis = [mapAxis(1)-1.5;mapAxis'];
mapAxis = [mapAxis; mapAxis(end)+1.5];
mapAxis = mapAxis';