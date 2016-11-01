clc;
clear;

%%
% shep = [  1   .69   .92    0     0     0   
%         -.8 .6624 .8740   0  -.0184   0
%         -.2 .1100 .3100  .22    0    -18
%         -.2 .1600 .4100 -.22    0     18
%          .1 .2100 .2500   0    .35    0
%          .1 .0460 .0460   0    .1     0
%          .1 .0460 .0460   0   -.1     0
%          .1 .0460 .0230 -.08  -.605   0 
%          .1 .0230 .0230   0   -.606   0
%          .1 .0230 .0460  .06  -.605   0   ];


%% Initial Settings
N = 200;
view = 500;
theta = 0:360/view:360 - 360/view;

% dot_interval = 0.1;
ray_interval = 1;
let = 2;
% DS_Factor = 10;

%% sino_Anal = zeros(N, length(theta));
% for i = 1:size(shep, 1)
%     sino_Anal = sino_Anal + sino_ellipse(shep(i, 1), shep(i, 2) * 10, shep(i, 3) * 10, ...
%         shep(i, 4) * 10, shep(i, 5) * 10, shep(i, 6), N, theta, ray_interval * 20/N, let, 0);
% end
% 
% fbp_Anal = FBP2(sino_Anal, N, theta, ray_interval, 1, 1, 0);

%% Forward Projection by DotCounting
ph1 = CustomPhantom(N, 6);
% ph2 = CustomPhantom(N, 1);
sino1 = DotCounting(ph1, 0.1, ray_interval, N, theta, let);
% sino2 = DotCounting(ph2, 0.01, ray_interval, N, theta, let);
fbp1 = FBP2(sino1, N, theta, ray_interval, 1, 1, 0);
% fbp2 = FBP2(sino2, N, theta, ray_interval, 1, 1, 0);

%% Figuring
figure, imshow(fbp1, []);
% figure, imshow(fbp2, []);
% figure, imshow(fbp3, []);