function visited = visitedBins(posx,posy,mapAxis)

binWidth = mapAxis(2)-mapAxis(1);

% Number of bins in each direction of the map
N = length(mapAxis);
visited = zeros(N);

for ii = 1:N
    for jj = 1:N
        px = mapAxis(ii);
        py = mapAxis(jj);
        distance = sqrt( (px-posx).^2 + (py-posy).^2 );
        
        if min(distance) <= binWidth
            visited(jj,ii) = 1;
        end
    end
end