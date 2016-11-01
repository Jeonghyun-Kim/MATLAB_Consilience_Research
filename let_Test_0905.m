clc;
clear;

%% Initial Conditions
A = 1;
rx = 1;
ry = 1;
x0 = 3;
y0 = 2;
alpha = 0;
N = 200;
view = 500;
theta = 0:360/view:360 - 360/view;

ray_interval = 1;

let = [1 2 5 10];

dot_interval = 0.1;

%% parameterize
% i : let

tic
for i = 1:length(let)
    sino_Anal = sino_ellipse(A, rx, ry, x0, y0, alpha, N, theta, ray_interval * 20/N, let(i), 0);
    sino_DC = DotCountingAnal(A, rx, ry, x0, y0, alpha, dot_interval, ray_interval * 20/N, N, theta, let(i));
    FBP_Anal = FBP2(sino_Anal, N, theta, ray_interval, 1, 1, 0);
    FBP_DC = FBP2(sino_DC, N, theta, ray_interval, 1, 1, 0);

    MAE_sino(i) = mean(mean(abs(sino_Anal - sino_DC)));
    MAE_fbp(i) = mean(mean(abs(FBP_Anal - FBP_DC)));
end
toc