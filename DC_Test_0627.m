%%
% close all;
clear;

%%
%relative : 20 by 20
A = 1;
rx = 1;
ry = 1;
x0 = 3;
y0 = 0;
alpha = 0;
N = 200;
theta = 0:359;
DS_Factor = 1;

dot_interval = 0.1;
ray_interval = 1;
let = 1;

% fFactor = 5;

threshold = 0.01;

% figure, imshow(phantom(E, N), []);
ph = MakePhantom(A, rx, ry, x0, y0, alpha, N, DS_Factor);


sino_Anal = sino_ellipse(A, rx, ry, x0, y0, alpha, N, theta, ray_interval * 20/N, let, 0);
sino_DC_Anal = DotCountingAnal(A, rx, ry, x0, y0, alpha, dot_interval, ray_interval * 20/N, N, theta, let);
sino_DC = DotCounting(ph, dot_interval, ray_interval, N, theta, let);

% sino_DC_hanning = convn(sino_DC, hanning(fFactor)'/sum(hanning(fFactor)), 'same');
% sino_DC_gaussian = convn(sino_DC, gausswin(fFactor)'/sum(gausswin(fFactor)), 'same');

%%

fbp_sino_Anal = FBP2(sino_Anal, N, theta, ray_interval, 1, 1, 0);
fbp_sino_DC_Anal = FBP2(sino_DC_Anal, N, theta, ray_interval, 1, 1, 0);
fbp_sino_DC = FBP2(sino_DC, N, theta, ray_interval, 1, 1, 0);

% fbp_sino_DC_hanning = FBP2(sino_DC_hanning, N, theta, 1, 1, 1, 0);
% fbp_sino_DC_gaussian = FBP2(sino_DC_gaussian, N, theta, 1, 1, 1, 0);

%%
% figure, imshow(ph, []);

%%
% Variance = var(var(fbp_sino_Anal - fbp_sino_DC))

%%
figure;
subplot(2, 3, 1);
imshow(sino_Anal, []);
title('Analytic Sinogram');
subplot(2, 3, 2);
imshow(sino_DC_Anal, []);
title('Analytic Sinogram by DC');
subplot(2, 3, 3);
imshow(sino_DC, []);
title('Sinogram by DC');
subplot(2, 3, 4);
imshow(fbp_sino_Anal, [-threshold, threshold]);
title('FBP Analytic');
subplot(2, 3, 5);
imshow(fbp_sino_DC_Anal, [-threshold, threshold]);
title('FBP Analytic by DC');
subplot(2, 3, 6);
imshow(fbp_sino_DC, [-threshold, threshold]);
title('FBP by DC');

%%
% figure;
% subplot(2, 4, 1);
% imshow(sino_Anal, []);
% title('Analytic Sinogram');
% subplot(2, 4, 2);
% imshow(sino_DC, []);
% title('Sinogram by DC');
% subplot(2, 4, 3);
% imshow(sino_DC_hanning, []);
% title('Sinogram by DC with Hanning Filtering');
% subplot(2, 4, 4);
% imshow(sino_DC_gaussian, []);
% title('Sinogram by DC with Gaussian Filtering');
% 
% subplot(2, 4, 5);
% imshow(fbp_sino_Anal, [-0.05 0.05]);
% title('FBP Analytic');
% subplot(2, 4, 6);
% imshow(fbp_sino_DC, [-0.05, 0.05]);
% title('FBP DC');
% subplot(2, 4, 7);
% imshow(fbp_sino_DC_hanning, [-0.05, 0.05]);
% title('FBP DC with Hanning Filtering');
% subplot(2, 4, 8);
% imshow(fbp_sino_DC_gaussian, [-0.05, 0.05]);
% title('FBP DC with Gaussian Filtering');

