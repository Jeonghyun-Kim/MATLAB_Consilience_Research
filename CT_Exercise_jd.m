%% Initialization

clc;
clear;
close all;

%% Condition Setting

tic;

rx = 0.02;
ry = 0.02;
x0 = 4;
y0 = 0;
alpha = -38;

N = 500;
view = 500;
let = 10;
pixel_amplifier = 2;
offset = 0.25;
ft_size = 10;

NoiseVariance = 0.01;

theta = 0:(360/view):(360 - 360/view);
E = [1 rx/10 ry/10 x0/10 y0/10 alpha];
interval = 20/N;

%% Sinogram Genaration

ph = phantom(E, N);
sino_matlab = radon(ph, theta);
%sino_FBP = sino_ellipse(rx, ry, x0, y0, alpha, N, theta, interval, let, 0);
sino_Offset = sino_ellipse(rx, ry, x0, y0, alpha, N, theta, interval, let, offset * let);
%sino_MTF = sino_ellipse(0.01, 0.01, 0, 0, 0, N, theta, interval, let, 0);

%% Comparing with iradon

% % sino4 = zeros(size(sino_matlab));
% % expansion_size = size(sino_matlab, 1) - N;
% % sino4(ceil(expansion_size/2):ceil(expansion_size/2) + N - 1, :) = sino_FBP;
% % ph_iradon = iradon(sino4, theta);

%% Filtered Back Projection

%[ph_FBP, sino_filter] = FBP(sino_FBP, N, theta, interval, pixel_amplifier, ft_size, 0);
ph_Offset = FBP(sino_Offset, N, theta, interval, pixel_amplifier, ft_size, offset);
return

%ph_Noise = FBP(sino_FBP + sqrt(NoiseVariance) .* randn(size(sino_FBP)), N, theta, interval, pixel_amplifier, ft_size, 0);
%ph_MTF = FBP(sino_MTF, N, theta, interval, pixel_amplifier, ft_size, 0);





return


%% Fourier Transform Implementation

fr_matlab = mat2gray(log(abs(fftshift(fft2(ph))) + 1));
fr_FBP = mat2gray(log(abs(fftshift(fft2(ph_FBP))) + 1));
fr_Offset = mat2gray(log(abs(fftshift(fft2(ph_Offset))) + 1));
fr_Noise = mat2gray(log(abs(fftshift(fft2(ph_Noise))) + 1));
MTF = mat2gray(log(abs(fftshift(fft2(ph_MTF))) + 1));

toc;

%% Result

OutputNoiseVariance = std2(ph_FBP - ph_Noise).^2;
OutputNoiseOverInputNoise = OutputNoiseVariance / NoiseVariance;

figure;
imshow(ph);
title('Ecllipse Phantom');

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

figure;
subplot(2, 2, 1);
plot(ph_iradon(length(ph_FBP)/2 + 1 - y0 * 50, :));
title('Center of iradon Phantom');
grid on;
subplot(2, 2, 2);
plot(ph_FBP(length(ph_FBP)/2 - y0 * 50, :));
title('Center of FBP Phantom');
grid on;
subplot(2, 2, 3);
plot(ph_FBP(length(ph_Offset)/2 - y0 * 50, :));
title('Center of Quarter Offset Phantom');
grid on;
subplot(2, 2, 4);
plot(fr_FBP(length(fr_FBP)/2, :));
title('MTF');
grid on;

figure;
subplot(2, 2, 1);
imshow(fr_matlab, []);
title('Phantom in Frequency Domain');
subplot(2, 2, 2);
imshow(fr_FBP, []);
title('Reconstructed Phantom in Frequency Domain');
subplot(2, 2, 3);
imshow(fr_Offset, []);
title('Quarter Offset Recon-Phantom in Frequency Domain');
subplot(2, 2, 4);
imshow(fr_Noise, []);
title('Noise Recon-Phantom in Frequency Domain');

figure;
subplot(2, 2, 1);
imshow(ph_iradon, []);
title('Reconstruction Image by iradon');
subplot(2, 2, 2);
imshow(ph_FBP, []);
title('Reconstruction Image by FBP');
subplot(2, 2, 3);
imshow(ph_Offset, []);
title('Reconstruction Image with Quarter Offset');
subplot(2, 2, 4);
imshow(ph_Noise, []);
title('Recontruction Image including Noise');
%% 

figure;
subplot(1, 2, 1);
imshow(ph_FBP, [-0.05 0.05]);
title('Reconstruction Image [-0.05 0.05]');
subplot(1, 2, 2);
imshow(ph_Offset, [-0.05 0.05]);
title('Reconstruction Offset Image [-0.05 0.05]');
%% 
figure;
imshow(MTF, []);
title('MTF');

figure;
subplot(1, 2, 1);
imshow(sqrt(NoiseVariance) .* randn(size(sino_FBP)), []);
title(['Input Noise Variance = ', num2str(NoiseVariance)]);
subplot(1, 2, 2);
imshow(ph_Noise - ph_FBP, []);
title(['Reconstruction Noise Variance = ', num2str(OutputNoiseVariance)]);