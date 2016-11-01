clear;
close all;
imagesize = 128;

rx = 3;
ry = 3;
x0 = 0;
y0 = 0;
alpha = 0;
E = [1 rx/10 ry/10 x0/10 y0/10 alpha];

SIZE = imagesize;
view = 360;
theta = 0:(360/view):(360 - 360/view);
num = imagesize;
i = 0;
sino = zeros(num, view);
tic;
for th = theta * pi/180
    i = i + 1;
    sino(:, i) = NMR_parallel(SIZE, phantom(E, SIZE), imagesize/3, imagesize/3, num, 1, th);
end
toc;

figure,imshow(sino, []);