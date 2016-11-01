clc
clear


a=randn(100);
a_nps=abs(fftshift(fftn(a))).^2;

std2(a).^2
sum(a_nps(:))