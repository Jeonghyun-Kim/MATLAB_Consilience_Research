rx = 10;
ry = 10;
x0 = 0;
y0 = 0;
alpha = 0;
N = 256;
theta = 0:359;

E = [1 rx/10 ry/10 x0/10 y0/10 alpha];

A = phantom(E, N);

figure, imshow(A, []);