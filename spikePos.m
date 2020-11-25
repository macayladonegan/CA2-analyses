function [spkx,spky,newTs] = spikePos(ts,posx,posy,post,cPost)
N = length(ts);
spkx = zeros(N,1);
spky = zeros(N,1);
newTs = zeros(N,1);
count = 0;
for ii = 1:N
    tdiff = (post-ts(ii)).^2;
    tdiff2 = (cPost-ts(ii)).^2;
    [m,ind] = min(tdiff);
    [m2,ind2] = min(tdiff2);
    % Check if spike is in legal time sone
    if m == m2
        count = count + 1;
        spkx(count) = posx(ind(1));
        spky(count) = posy(ind(1));
        newTs(count) = ts(ii);
    end
end
spkx = spkx(1:count);
spky = spky(1:count);
newTs = newTs(1:count);