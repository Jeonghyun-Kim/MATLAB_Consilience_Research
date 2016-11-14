%% clc & clear
clc;
clear;
close all;

%% Initial Settings
iter_num = 3;
N = 200;
view = 301;
theta = 0:180/view:180 - 180/view;

dot_interval = 0.1;
ray_interval = 1;
let = 1;
DS_Factor = 5;

%% Grid Settings
x_grid = repmat(linspace(-(N-1)/2, (N-1)/2, N), N, 1);
y_grid = repmat(linspace(-(N-1)/2, (N-1)/2, N)', 1, N);
distance = sqrt(x_grid.^2 + y_grid.^2);
FOV_index = find(distance >= N/2);

dy=(N/2-0.5):-1:-(N/2-0.5);

recon_x_temp = repmat(-(N/2 - 0.5):(N/2 - 0.5), N, 1);
recon_y_temp = (N/2 - 0.5):-1:-(N/2 - 0.5);
recon_y_temp = repmat(recon_y_temp', 1, N);

%% Prepare Images
ph = phantom(N);
ph_DS = CustomPhantom(N, DS_Factor);
img_weight = ones(N);
proj = DotCounting(ph_DS, dot_interval, ray_interval, N, theta, let);
proj_weight = DotCounting(img_weight, dot_interval, ray_interval, N, theta, let);
img_iter = zeros(N);

keyboard;

%% Iterative Reconstruction
for iter = 1:iter_num
    iter
    proj_filtered = (proj - DotCounting(img_iter, dot_interval, ray_interval, N, theta, let))./proj_weight/2;
    view_count = 0;
    for rad = (theta .* pi ./180)
        view_count = view_count + 1;
        recon_y = -recon_y_temp .* sin(rad) + recon_x_temp .* cos(rad);
        y_mapped = recon_y(:);
        recon_value = interp1(dy, proj_filtered(:, view_count), y_mapped);
        recon = reshape(recon_value, N, N);
        img_iter = img_iter + recon;
%         index = find(img_iter < 0);
%         img_iter(index) = 0;
%         img_iter(FOV_index) = 0;
    end
    figure, imshow(img_iter, []);
    str = sprintf('iteration %d', iter);
    title(str);
end