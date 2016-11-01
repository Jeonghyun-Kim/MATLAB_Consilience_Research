function proj = projection(dx,dy,sx,sy,xc,yc,r)

slope=(sy-dy)/(sx-dx);
d=(yc-xc*slope+dx*slope-dy)/sqrt(slope^2+1);
%keyboard
if imag(sqrt(r^2-d^2))==0
    proj=2*sqrt(r^2-d^2);
else
    proj=0;
end

%keyboard
