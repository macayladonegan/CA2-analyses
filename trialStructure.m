load('spks.mat')


%plot left cup
figure
plot(posx,posy)
%title([initials,'imported.mat'])
hold on
[xcup,ycup]=pol2cart([1:360],(ones(1,360)*25));
plot(xcup-150,ycup,'go')
plot(-150,ycup,'rp')
cup=0;
while cup==0
cup=input('is the cup centered? 1 for yes, 0 for no');
if cup==0
xc=input('what is the x value of the cup center?');
yc=input('what is the y value of the cup center?');
[ang,rho]=cart2pol(posx-xc,posy-yc);
close(gcf)
figure
plot(posx,posy)
%title([initials,'imported.mat'])
hold on
[xcup,ycup]=pol2cart([1:360],(ones(1,360)*25));

plot(xcup+xc,ycup+yc,'go')
plot(xc,yc,'rp')
else
[ang,rho]=cart2pol(posx-150,posy);
end
end

saveas(gcf,'xy cm path')

close all

%find poses when when animal is within some radius q of the cup

figure
plot(posx,posy)
%title([initials,'imported.mat'])
hold on
plot(xcup+xc,ycup+yc,'go')
plot(xc,yc,'rp')
[xcup_q,ycup_q]=pol2cart([1:360],(ones(1,360)*50));
plot(xcup_q-150,ycup_q,'go')
plot(-150,ycup_q,'rp')
cupQ=0;
while cupQ==0
cupQ=input('is the cup centered? 1 for yes, 0 for no');
if cupQ==0
xc_q=input('what is the x value of the cup center?');
yc_q=input('what is the y value of the cup center?');
[ang,rho]=cart2pol(posx-xc_q,posy-yc_q);
close(gcf)
figure
plot(posx,posy)
%title([initials,'imported.mat'])
hold on
[xcup_q,ycup_q]=pol2cart([1:360],(ones(1,360)*25));

plot(xcup_q+xc_q,ycup_q+yc_q,'go')
plot(xc_q,yc_q,'rp')
else
[ang,rho]=cart2pol(posx-145,posy);
end
end







