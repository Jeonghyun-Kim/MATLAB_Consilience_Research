% close all;
clear;

%% phantom Settings
%         A    a     b    x0    y0    phi
%        ---------------------------------
shep = [  1   .69   .92    0     0     0   
        -.79 .6624 .8740   0  -.0184   0
        -.2 .1100 .3100  .22    0    -18
        -.2 .1600 .4100 -.22    0     18
         .1 .2100 .2500   0    .35    0
         .1 .0460 .0460   0    .1     0
         .1 .0460 .0460   0   -.1     0
         .1 .0460 .0230 -.08  -.605   0 
         .1 .0230 .0230   0   -.606   0
         .1 .0230 .0460  .06  -.605   0   ];

%% Initial Settings
N = 200;
theta = 0:359;

dot_interval = 0.1;
ray_interval = 1;
let = 1;
DS_Factor = 2;

%% Analytic Sinogram Generation
sino_Anal = zeros(N, length(theta));
for i = 1:size(shep, 1)
    sino_Anal = sino_Anal + sino_ellipse(shep(i, 1), shep(i, 2) * 10, shep(i, 3) * 10, ...
        shep(i, 4) * 10, shep(i, 5) * 10, shep(i, 6), N, theta, ray_interval * 20/N, let, 0);
end

fbp_Anal = FBP(sino_Anal, N, theta, 1, 1, 1, 0);
%% Sinogram Generation by DotCounting - Analytic
% sino_DC_Anal = zeros(N, length(theta));
% for i = 1:size(shep, 1)
% %     keyboard
%     sino_DC_Anal = sino_DC_Anal + DotCountingAnal(shep(i, 1), shep(i, 2) * 10, shep(i, 3) * 10, ...
%         shep(i, 4) * 10, shep(i, 5) * 10, shep(i, 6), dot_interval, ray_interval * 20/N, N, theta, let);
% end
% fbp_DC_Anal = FBP2(sino_DC_Anal, N, theta, 1, 1, 1, 0);

%% Forward Projection by DotCounting
ph = CustomPhantom(N, 1);
ph_DS = CustomPhantom(N, DS_Factor);
sino = DotCounting(ph, dot_interval, ray_interval, N, theta, let);
sino_DS = DotCounting(ph_DS, dot_interval, ray_interval, N, theta, 1);
fbp = FBP(sino, N, theta, 1, 1, 1, 0);
fbp_DS = FBP(sino_DS, N, theta, 1, 1, 1, 0);

%% Load Down-Sampling x100
% load('cus_ph200_100x.mat');
% sino_DS2 = DotCounting(result, dot_interval, ray_interval, N, theta);
% fbp_DS2 = FBP2(sino_DS2, N, theta, 1, 1, 1, 0);

%% Figuring
% figure;
% imshow(phantom(500), []);

figure;
subplot(2, 3, 1);
imshow(sino_Anal, []);
title('Analytic Sinogram with let');
% subplot(2, 4, 2);
% imshow(sino_DC_Anal, []);
% title('Analytic Sinogram by DC');
subplot(2, 3, 2);
imshow(sino, []);
title('Sinogram by DCt');
subplot(2, 3, 3);
imshow(sino_DS, []);
title('Sinogram by DC with Down-Sampling10x');
% subplot(2, 4, 4);
% imshow(sino_DS2, []);
% title('Sinogram by DC with Down-Sampling100x');

subplot(2, 3, 4);
imshow(fbp_Anal, []);
title('FBP Analytic with let');
% subplot(2, 4, 6);
% imshow(fbp_DC_Anal, []);
% title('FBP Analytic by DC');
subplot(2, 3, 5);
imshow(fbp, []);
title('FBP by DC');
subplot(2, 3, 6);
imshow(fbp_DS, []);
title('FBP by DC with Down-Sampling10x');
% subplot(2, 4, 8);
% imshow(fbp_DS, []);
% title('FBP by DC with Down-Sampling100x');