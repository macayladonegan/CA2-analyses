function drawfield(map,axis,cmap,maxrate,binWidth,smoothing)
maxrate = ceil(maxrate);
if maxrate < 1
    maxrate = 1;
end    
n = size(map,1);
plotmap = ones(n,n,3);
for jj = 1:n
   for ii = 1:n
      if isnan(map(jj,ii))
         plotmap(jj,ii,1) = 1;
         plotmap(jj,ii,2) = 1;
		 plotmap(jj,ii,3) = 1;
      else
         rgb = pixelcolour(map(jj,ii),maxrate,cmap);
         plotmap(jj,ii,1) = rgb(1);
         plotmap(jj,ii,2) = rgb(2);
		 plotmap(jj,ii,3) = rgb(3);
      end   
   end
end   
image(axis,axis,plotmap);
set(gca,'YDir','Normal');
s = sprintf('%s%u%s%2.1f%s%3.1f','Peak ',maxrate,' Hz.');
title(s);