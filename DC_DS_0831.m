clc;
clear;

%%
A = 1;
rx = 2;
ry = 1;
x0 = -3;
y0 = -4;
alpha = 0;
N = 200;
view = 500;
theta = 0:360/view:360 - 360/view;

ray_interval = 1;

trial = [1 2 5 10];
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
    ph_DS = MakePhantom(A, rx, ry, x0, y0, alpha, N, DS_Factor(i));
    for j = 1:count
        for k = 1:count
            sino_Anal = sino_ellipse(A, rx, ry, x0, y0, alpha, N, theta, ray_interval * 20/N, let(j), 0);
            sino_DC = DotCounting(ph_DS, dot_interval(k), ray_interval, N, theta, let(j));
            FBP_Anal = FBP2(sino_Anal, N, theta, ray_interval, 1, 1, 0);
            FBP_DC = FBP2(sino_DC, N, theta, ray_interval, 1, 1, 0);
            
            MAE_sino(i, j, k) = mean(mean(abs(sino_Anal - sino_DC)));
            MAE_fbp(i, j, k) = mean(mean(abs(FBP_Anal - FBP_DC)));
        end
    end
end
toc