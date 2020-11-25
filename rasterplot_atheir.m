function rasterplot_atheir(x,y)

h=line(repmat(y,2,1),[x.*ones(1,length(y));(x+5).*ones(1,length(y))]);

set(h,'Color','k')

hold on

end