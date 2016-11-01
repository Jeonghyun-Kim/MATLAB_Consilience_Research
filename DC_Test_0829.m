clc
clear

%%
A = 1;
rx = 1;
ry = 1;
x0 = 3;
y0 = 0;
alpha = 0;
N = 200;
view = 500;
theta = 0:360/view:360 - 360/view;
DS_Factor = 10;

dot_interval = 0.1;
ray_interval = 1;
let = 1;

threshold = 0.01;

ph = MakePhantom(A, rx, ry, x0, y0, alpha, N, 1);
ph_DS = MakePhantom(A, rx, ry, x0, y0, alpha, N, DS_Factor);
% load('ph200_100x.mat');

%%
sino = DotCounting(ph, dot_interval, ray_interval, N, theta, let);
sino_DS = DotCounting(ph_DS, dot_interval, ray_interval, N, theta, let);
% sino_DS2 = DotCounting(result, dot_interval, ray_interval, N, theta, let);

sino_Anal = sino_ellipse(A, rx, ry, x0, y0, alpha, N, theta, ray_interval * 20/N, 1, 0);
sino_Anal_let = sino_ellipse(A, rx, ry, x0, y0, alpha, N, theta, ray_interval * 20/N, let, 0);

%%
fbp = FBP(sino, N, theta, ray_interval, 1, 1, 0);
fbp_DS = FBP(sino_DS, N, theta, ray_interval, 1, 1, 0);
% fbp_DS2 = FBP2(sino_DS2, N, theta, ray_interval, 1, 1, 0);

fbp_sino_Anal = FBP(sino_Anal, N, theta, ray_interval, 1, 1, 0);
fbp_sino_Anal_let = FBP(sino_Anal_let, N, theta, ray_interval, 1, 1, 0);

%%
figure;
subplot(2, 3, 1);
imshow(sino, []);
title('Sinogram');
subplot(2, 3, 4);
imshow(sino_DS, []);
title('Sinogram with Down-Sampling10x');
% subplot(3, 3, 3);
% imshow(sino_DS2, []);
% title('Sinogram with Down-Sampling100x');
subplot(2, 3, 2);
imshow(ph, []);
title('Original Image');
subplot(2, 3, 5);
imshow(ph_DS, []);
title('Original Image Down-Sampling10x');
% subplot(3, 3, 6);
% imshow(result, []);
% title('Original Image Down-Sampling100x');
subplot(2, 3, 3);
imshow(fbp, []);
title('Reconstruction Image');
subplot(2, 3, 6);
imshow(fbp_DS, []);
title('Reconstruction Image Down-Sampling10x');
% subplot(3, 3, 9);
% imshow(fbp_DS2, [-threshold, threshold]);
% title('Reconstruction Image Down-Sampling100x');

%%
figure;
subplot(2, 4, 1);
imshow(sino_Anal, []);
title('Analytic Sinogram');
subplot(2, 4, 2);
imshow(sino_Anal_let, []);
title('Analytic Sinogram Using Let');
subplot(2, 4, 3);
imshow(sino, []);
title('Sinogram by Dot-Counting');
subplot(2, 4, 4);
imshow(sino_DS, []);
title('Sinogram with Down-Sampling10x');
subplot(2, 4, 5);
imshow(fbp_sino_Anal, [-threshold, threshold]);
title('Reconstruction Image Analytic');
subplot(2, 4, 6);
imshow(fbp_sino_Anal_let, [-threshold, threshold]);
title('Reconstruction Image Analytic Using Let');
subplot(2, 4, 7);
imshow(fbp, [-threshold, threshold]);
title('Reconstruction Image by Dot-Counting');
subplot(2, 4, 8);
imshow(fbp_DS, [-threshold, threshold]);
title('Reconstruction Image Down-Sampling10x');