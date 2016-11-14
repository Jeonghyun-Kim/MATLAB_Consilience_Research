%% Initialization

clc;
clear;
close all;

%% Condition Setting

% MTF Condition
% rx = 0.1;
% ry = 0.1;
% x0 = 0.2;
% y0 = 0;
% N = 200;
% view = 300;
% let = 10;

rx = 0.1;
ry = 0.1;
x0 = 0.2;
y0 = 0;
alpha = 0;

N = 400;
view = 400;
let = 10;
pixel_amplifier = 2;
offset = 0.25;
ft_size = 10;

N_in = 10^5;

theta = 0:(360/view):(360 - 360/view);
E = [1 rx/10 ry/10 x0/10 y0/10 alpha];
interval = 20/N;

%% Sinogram Genaration

tic;

ph = phantom(E, N);
sino_matlab = radon(ph, theta);
sino_FBP = sino_ellipse(rx, ry, x0, y0, alpha, N, theta, interval, let, 0);
sino_Offset = sino_ellipse(rx, ry, x0, y0, alpha, N, theta, interval, let, offset);

%% Comparing with iradon

sino4 = zeros(size(sino_matlab));
expansion_size = size(sino_matlab, 1) - N;
sino4(ceil(expansion_size/2):ceil(expansion_size/2) + N - 1, :) = sino_FBP;
ph_iradon = iradon(sino4, theta);

%% Filtered Back Projection

[ph_FBP, sino_filter] = FBP(sino_FBP, N, theta, interval, pixel_amplifier, ft_size, 0);
ph_Offset = FBP(sino_Offset, N, theta, interval, pixel_amplifier, ft_size, offset * interval);
ph_Noise = FBP(log(N_in) - log(poissrnd(N_in, size(sino_FBP))), N, theta, interval, pixel_amplifier, ft_size, 0);   


%% Fourier Transform Implementation

fr_matlab = abs(fftshift(fftn(ph)));
fr_FBP = abs(fftshift(fftn(ph_FBP)));
fr_Offset = abs(fftshift(fftn(ph_Offset)));
fr_Noise = abs(fftshift(fftn(ph_Noise)));

toc;

%% Result

Variance1 = std2(ph_Noise)^2
Variance2 = (pi^2 * interval * 2 / view / N_in.^2) * sum(fr_Noise(:).^2)

% return;
%% 
% figure;
% imshow(ph);
% title('Ecllipse Phantom');
%% 
figure;
subplot(2, 2, 1);
imshow(sino_matlab, []);
title('Sinogram by MATLAB');
subplot(2, 2, 2);
imshow(sino_FBP, []);
title('Simulated Sinogram');
subplot(2, 2, 3);
imshow(sino_Offset, []);
title('Quarter Offset Sinogram');
subplot(2, 2, 4);
imshow(sino_filter, []);
title('Ramp Filtered Sinogram');
%% 
figure;
subplot(1, 3, 1);
imshow(ph_iradon, []);
title('Reconstruction Image by iradon');
subplot(1, 3, 2);
imshow(ph_FBP, []);
title('Reconstruction Image by FBP');
subplot(1, 3, 3);
imshow(ph_Offset, []);
title('Reconstruction Image with Quarter Offset');
%% 
figure('units', 'normalized', 'outerposition', [0 0.2 0.8 0.8]);
subplot(2, 4, 1);
imshow(ph_FBP, [-0.05 0.05]);
title('Reconstruction Image [-0.05 0.05]');
subplot(2, 4, 2);
plot(ph_FBP(round(length(ph_FBP)/2), :));
title('Center of FBP Phantom');
grid on;
subplot(2, 4, 3);
imshow(fr_FBP, []);
title('Reconstructed Phantom in Frequency Domain');
subplot(2, 4, 4);
plot(fr_FBP(round(length(fr_FBP)/2) + 1, :));
title('MTF of FBP Phantom');
grid on;
subplot(2, 4, 5);
imshow(ph_Offset, [-0.05 0.05]);
title('Quarter Offset Implemented Image [-0.05 0.05]');
subplot(2, 4, 6);
plot(ph_FBP(round(length(ph_Offset)/2), :));
title('Center of Quarter Offset Phantom');
grid on;
subplot(2, 4, 7);
imshow(fr_Offset, []);
title('Quarter Offset Recon-Phantom in Frequency Domain');
subplot(2, 4, 8);
plot(fr_Offset(round(length(fr_Offset)/2) + 1, :));
title('MTF of Quarter Offset Phantom');
grid on;
%%
figure;
imshow(fr_Noise, []);
title('Noise Power Spectrum');