clc;
clear;

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
N = 200;
view = 500;
theta = 0:360/view:360 - 360/view;

ray_interval = 1;

trial = 1:10;
count = length(trial);

dot_interval = 0.2 ./ trial;
DS_Factor = trial;
let = trial;
% MAE is Mean Absolute Error
MAE_sino = NaN(count, count, count);
MAE_fbp = NaN(count, count, count);

%% parameterize
% i : down sampling
% j : let
% k : dot density

tic
for i = 1:count
    ph_DS = CustomPhantom(N, DS_Factor(i));
    for j = 1:count
        for k = 1:count
            sino_Anal = zeros(N, length(theta));
            for m = 1:size(shep, 1)
                sino_Anal = sino_Anal + sino_ellipse(shep(m, 1), shep(m, 2) * 10, shep(m, 3) * 10, ...
                    shep(m, 4) * 10, shep(m, 5) * 10, shep(m, 6), N, theta, ray_interval * 20/N, let(j), 0);
            end
            sino_DC = DotCounting(ph_DS, dot_interval(k), ray_interval, N, theta, let(j));
            FBP_Anal = FBP2(sino_Anal, N, theta, ray_interval, 1, 1, 0);
            FBP_DC = FBP2(sino_DC, N, theta, ray_interval, 1, 1, 0);
            
            MAE_sino(i, j, k) = mean(mean(abs(sino_Anal - sino_DC)));
            MAE_fbp(i, j, k) = mean(mean(abs(FBP_Anal - FBP_DC)));
        end
    end
end
toc