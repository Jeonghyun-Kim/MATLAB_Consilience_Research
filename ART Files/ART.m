%% clc & clear
clc;
clear;

%% Initial Settings
iter_num = 3;
N = 200;
view = 501;
theta = 0:360/view:360 - 360/view;

dot_interval = 0.1;
ray_interval = 1;
let = 1;
DS_Factor = 5;

%% Prepare Images
ph = phantom(N);
ph_DS = CustomPhantom(N, DS_Factor);
img_weight = ones(N);
proj = DotCounting(ph_DS, dot_interval, ray_interval, N, theta, let);
proj_weight = DotCounting(img_weight, dot_interval, ray_interval, N, theta, let);
img_iter = zeros(N);

%% Iterative Reconstruction
for iter = 1:iter_num
    iter
    proj_filtered = (proj - DotCounting(img_iter, dot_interval, ray_interval, N, theta, let))./proj_weight/2;
    %
    %
    %
    %
    img_iter = img_iter + recon;
    figure, imshow(img_iter);
    str = sprintf('iteration %d', iter);
    title(str);
end