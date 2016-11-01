function [rx1, ry1]=rotation(x1, y1,theta)

rx1=x1*cos(theta)-y1*sin(theta);
ry1=x1*sin(theta)+y1*cos(theta);
