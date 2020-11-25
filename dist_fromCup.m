function[dist_cup,avgDist]=dist_fromCup(posx,posy,spkx,spky,cups_x,cups_y)

%distance from cup

% figure(1)
% plot(posx,posy,'k')
% hold on
% [xcup,ycup]=pol2cart([1:360],(ones(1,360)*5));
% plot(xcup+4,ycup+max(posy)/2,'go')
% plot(4,max(posy)/2,'rp')
% axis([-40 40 -25 25]);
%find left cup center


    xc=cups_x;
    yc=cups_y;
    %plot(xcup+xc,ycup+yc,'go')
    %plot(xc,yc,'rp')
    

[spkx_r,spky_r]=cart2pol(spkx,spky);

hold on
polar(spkx_r,spky_r,'.r');


spk_r=horzcat(spkx_r,spky_r);
c=repmat([xc;yc],[1,length(spkx)])';
%find vector distance between two points
dist_cup=ones(length(spkx_r),1);
for i=1:length(spkx_r)
    dist_cup(i)=norm(spk_r(i,:)-c(i,:));
end

avgDist=mean(dist_cup);