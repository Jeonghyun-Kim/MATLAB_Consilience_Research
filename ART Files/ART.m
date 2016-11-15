%% clc & clear
clc;
clear;
close all;

%% Initial Settings
echo on;

iter_num = 6;
N = 256;
view = 101;
theta = 0:180/view:180 - 180/view;

dot_interval = 0.1;
ray_interval = 1;
relaxation_factor = 2;
let = 1;
DS_Factor = 5;

%% Grid Settings
X = repmat((- N/2 + 0.5) * ray_interval:ray_interval:(N/2 - 0.5) * ray_interval, N, 1);
Y = repmat(((N/2 - 0.5) * ray_interval:-ray_interval:(- N/2 + 0.5) * ray_interval)', 1, N);
AXIS = (- N/2 + 0.5) * ray_interval:ray_interval:(N/2 - 0.5) * ray_interval;

%% Prepare Images
% ph = phantom(N);
tic;
ph_DS = CustomPhantom(N, DS_Factor);
toc;
img_weight = ones(N);
proj_weight = DotCounting(img_weight, dot_interval, ray_interval, N, theta, let);
proj = DotCounting(ph_DS, dot_interval, ray_interval, N, theta, let);
img_iter = zeros(N);

echo off;

%% Iterative Reconstruction
for iter = 1:iter_num
    iter
    view_count = 0;
    tic;
    for th = theta .* pi ./180
        view_count = view_count + 1;
        proj_filtered = (proj(:, view_count) - DotCounting(img_iter, dot_interval, ray_interval, N, th * 180/pi, let))...
            ./proj_weight(:, view_count)/relaxation_factor;
        recon = interp1(AXIS, proj_filtered', Y .* sin(th) + X .* cos(th), 'linear');
        index = (isnan(recon) == 1);
        recon(index) = 0;
        img_iter = img_iter + recon;
        index = (img_iter < 0);
        img_iter(index) = 0;
    end
    toc;
    A{iter} = img_iter;
end

%% Figuring
for i = 1:iter_num
    figure;
    imshow(A{i}, []);
    str = sprintf('iteration %d', i);
    title(str);
end

%% Figuring together (6 iterations)
figure;
for i = 1:6
    subplot(2, 3, i);
    imshow(A{i}, []);
    str = sprintf('iteration %d', i);
    title(str);
end