function RADON = NMR3(SIZE, IMAGE, SCD, DCD, num, itv, theta)
count = 0;
den = 0.1;
CEN = round(SIZE*0.5);
RADON = zeros(num, 1);
p = zeros(4*round(SCD));
p(2*round(SCD)-CEN:2*round(SCD)-CEN+SIZE-1, 2*round(SCD)-CEN:2*round(SCD)-CEN+SIZE-1) = IMAGE;
x = den+round(SCD):den:round(SCD)+SCD+DCD;
y = repmat(2*round(SCD), 1, size(x,2));
x_rot1 = cos(-theta)*(x-2*SCD)-sin(-theta)*(y-2*SCD)+2*SCD;
y_rot1 = sin(-theta)*(x-2*SCD)+cos(-theta)*(y-2*SCD)+2*SCD;
for n = -round(num*0.5):num-round(num*0.5)-1
    count = count+1;
    rad = -atan(n*itv/(SCD+DCD));
    x_rot2 = cos(rad)*(x_rot1-x_rot1(1))-sin(rad)*(y_rot1-y_rot1(1))+x_rot1(1);
    y_rot2 = sin(rad)*(x_rot1-x_rot1(1))+cos(rad)*(y_rot1-y_rot1(1))+y_rot1(1);
    RADON(count,1) = sum(p(size(p,1)*(floor(y_rot2)-1)+floor(x_rot2)))*den;
end
end