figure(1)
h = animatedline;
axis([min(R.Pos.x1)-2, max(R.Pos.x1)+2,  min(R.Pos.y1)-2, max(R.Pos.y1)+2])

x = R.Pos.x1;
y = R.Pos.y1;
for k = 1:length(x)
    addpoints(h,x(k),y(k));
    drawnow
end