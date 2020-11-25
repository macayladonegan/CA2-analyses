function [x,y,t]=CleanPos(xytl)
%%vel filter
xytl=naninterp(xytl,'previous');
x=xytl(:,1);
y=xytl(:,2);t=xytl(:,3);
xx=diff(x);
thresh=find(abs(xx)>2*nanstd(xx));
x(thresh+1)=NaN;
y(thresh+1)=NaN;
yy=diff(y);
thresh2=find(abs(yy)>2*nanstd(yy));
x(thresh2+1)=NaN;
y(thresh2+1)=NaN;

%%plot to remove stray bad values before interp

    x(x>125)=NaN; x(x<10)=NaN;
    y(y>200)=NaN;y(y<0)=NaN;
    y(isnan(x))=NaN;x(isnan(y))=NaN;
    plot(x,y)
    filterWidth=1;
    x=filterGauss(x,filterWidth);y=filterGauss(y,filterWidth);
    y(isnan(y)) = interp1(find(~isnan(y)), y(~isnan(y)), find(isnan(y)),'linear','extrap');
    x(isnan(x)) = interp1(find(~isnan(x)), x(~isnan(x)), find(isnan(x)),'linear','extrap');

    scale_x=range(x)/65;
    x=x/scale_x;
     
    scale_y=range(y)/41;
    y=y/scale_y;
    centre = centreBox(x,y);

%center the positions
centre = centreBox(x,y);
x = x - centre(1);
y= y - centre(2);
    
    
 
    
    

