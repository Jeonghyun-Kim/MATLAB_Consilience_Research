clc;
clear;
close all;
%%
load('1014result');

%% phantom Settings
%         A    a     b    x0    y0    phi
%        ---------------------------------
shep = [  1   .69   .92    0     0     0   
        -.8 .6624 .8740   0  -.0184   0
        -.2 .1100 .3100  .22    0    -18
        -.2 .1600 .4100 -.22    0     18
         .1 .2100 .2500   0    .35    0
         .1 .0460 .0460   0    .1     0
         .1 .0460 .0460   0   -.1     0
         .1 .0460 .0230 -.08  -.605   0 
         .1 .0230 .0230   0   -.606   0
         .1 .0230 .0460  .06  -.605   0   ];
     
%% Analytic Sinogram Generation
sino_Anal = zeros(N, length(theta));
for i = 1:size(shep, 1)
    sino_Anal = sino_Anal + sino_ellipse(shep(i, 1), shep(i, 2) * 10, shep(i, 3) * 10, ...
        shep(i, 4) * 10, shep(i, 5) * 10, shep(i, 6), N, theta, ray_interval * 20/N, let, 0);
end

fbp_Anal = FBP2(sino_Anal, N, theta, ray_interval, 1, 1, 0);

%%
MSE = mean(mean((fbp - fbp_Anal).^2))

%%
figure, imshow(sino, []);
T = get(gca,'tightinset');
set(gca,'position',[T(1) T(2) 1-T(1)-T(3) 1-T(2)-T(4)]);
figure, imshow(sino_worst, []);
T = get(gca,'tightinset');
set(gca,'position',[T(1) T(2) 1-T(1)-T(3) 1-T(2)-T(4)]);
figure, imshow(fbp, []);
T = get(gca,'tightinset');
set(gca,'position',[T(1) T(2) 1-T(1)-T(3) 1-T(2)-T(4)]);
figure, imshow(fbp_worst, []);
T = get(gca,'tightinset');
set(gca,'position',[T(1) T(2) 1-T(1)-T(3) 1-T(2)-T(4)]);