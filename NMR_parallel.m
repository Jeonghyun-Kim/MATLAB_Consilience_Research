function RADON = NMR_parallel(SIZE, IMAGE, SCD, DCD, num, itv, theta)
%SCD is a distance between source and center
%DCD is a distance between detector and center
%num is the number of CT-ray
%itv is an interval of rays
%theta is the angle
den = 0.1;      %dot distance(density)
count = 0;
RADON = zeros(num, 1);  %output image
p = zeros(ceil(2*SCD+2*DCD));  
p(round(2*SCD)-round(SIZE/2):round(2*SCD)-round(SIZE/2)+SIZE-1,round(2*SCD)-round(SIZE/2):round(2*SCD)-round(SIZE/2)+SIZE-1) = IMAGE;
%p is the input image of algorithm
x = den+round(SCD):den:round(SCD)+SCD+DCD;
%x coordinate of dots before rotating
for n = -round(num*0.5):num-round(num*0.5)-1        %for-loop for each rays
    count = count+1;
    y = repmat(n*itv+round(2*SCD), 1, size(x,2));
    keyboard
    %y coordinate of dots before rotating
    x_rot = cos(theta)*(x-round(2*SCD))-sin(theta)*(y-round(2*SCD))+round(2*SCD);   %rotating process
    y_rot = sin(theta)*(x-round(2*SCD))+cos(theta)*(y-round(2*SCD))+round(2*SCD);   %rotating process
    %x, y coordinates of dots after rotating
    RADON(count,1) = sum(p(size(p,1)*(round(y_rot)-1)+round(x_rot)))*den;
    %counting dots by 'sum' function
end
end