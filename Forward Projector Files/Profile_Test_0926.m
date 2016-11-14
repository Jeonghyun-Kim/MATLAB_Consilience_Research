clc;
clear;

%%
A = 1;
rx = 1;
ry = 1;
x0 = 3;
y0 = 0;
alpha = 0;
N = 200;
view = 500;
theta = 0:360/view:360 - 360/view;
ray_interval = 1;
threshold = 0.1;

dot_interval = 0.1;
DS_Factor = 5;
let = 2;

%%
ph = MakePhantom(A, rx, ry, x0, y0, alpha, N, 1);
ph_DS = MakePhantom(A, rx, ry, x0, y0, alpha, N, DS_Factor);

sino_Anal = sino_ellipse(A, rx, ry, x0, y0, alpha, N, theta, ray_interval * 20/N, let, 0);
sino_DC = DotCounting(ph, dot_interval, ray_interval, N, theta, let);
sino_DS = DotCounting(ph_DS, dot_interval, ray_interval, N, theta, let);

FBP_Anal = FBP2(sino_Anal, N, theta, ray_interval, 1, 1, 0);
FBP_DC = FBP2(sino_DC, N, theta, ray_interval, 1, 1, 0);
FBP_DS = FBP2(sino_DS, N, theta, ray_interval, 1, 1, 0);

%%
figure;
subplot(3, 3, 1);
imshow(FBP_Anal, [-threshold threshold]);
title('Reconstruction Image Analytic');
subplot(3, 3, 2);
plot(FBP_Anal(N/2 - 10 * y0, :));
grid on;
title('Horizontal Profile');
subplot(3, 3, 3);
plot(FBP_Anal(:, N/2 + 10 * x0));
grid on;
title('Vertical Profile');
subplot(3, 3, 4);
imshow(FBP_DC, [-threshold threshold]);
title('Reconstruction Image DotCounting');
subplot(3, 3, 5);
plot(FBP_DC(N/2 - 10 * y0, :));
grid on;
title('Horizontal Profile');
subplot(3, 3, 6);
plot(FBP_DC(:, N/2 + 10 * x0));
grid on;
title('Vertical Profile');
subplot(3, 3, 7);
imshow(FBP_DS, [-threshold threshold]);
title('Reconstruction Image DownSampling');
subplot(3, 3, 8);
plot(FBP_DS(N/2 - 10 * y0, :));
grid on;
title('Horizontal Profile');
subplot(3, 3, 9);
plot(FBP_DS(:, N/2 + 10 * x0));
grid on;
title('Vertical Profile');