clc;
clear;
close all;

%%
load('0911/0911_shep.mat');

for i = 1:length(let)
    DS_fbp(i) = mean(mean(MAE_fbp(i, :, :)));
    let_fbp(i) = mean(mean(MAE_fbp(:, i, :)));
    dot_fbp(i) = mean(mean(MAE_fbp(:, :, i)));
    DS_sino(i) = mean(mean(MAE_sino(i, :, :)));
    DS_error(i) = std2(MAE_sino(i, :, :));
    let_sino(i) = mean(mean(MAE_sino(:, i, :)));
    let_error(i) = std2(MAE_sino(:, i, :));
    dot_sino(i) = mean(mean(MAE_sino(:, :, i)));
    dot_error(i) = std2(MAE_sino(:, :, i));
%     DS_fbp(i) = mean(MAE_fbp(i, 1, :));
%     dot_fbp(i) = mean(MAE_fbp(:, 1, i));
%     DS_sino(i) = mean(MAE_sino(i, 1, :));
%     dot_sino(i) = mean(MAE_sino(:, 1, i));
end

%%
% figure;
% hold on;
% grid on;
% plot(DS_fbp, 'r');
% plot(dot_fbp, 'b');
% plot(let_fbp, 'g');
% legend('Down-Sampling', 'Dot Interval', 'Let');
% title('Mean Absolute Error of Reconstruction Image');
% xlabel('DS\_Factor, 0.2 * dot density, let');
% ylabel('MAE');

%%
% figure;
% hold on;
% grid on;
% plot(DS_sino, 'r');
% plot(dot_sino, 'b');
% plot(let_sino, 'g');
% legend('Down-Sampling', 'Dot Interval', 'Let');
% title('Mean Absolute Error of Sinogram');
% xlabel('DS\_Factor, 0.2 * dot density, let');
% ylabel('MAE');

%%
figure;
hold on;
grid on;
box on;
errorbar(1:10, DS_sino, DS_error, 'o:');
axis([0 11 0.035 0.07501]);
xlabel('Down-sampling factor');
ylabel('MAE');

%%
figure;
hold on;
grid on;
box on;
errorbar(1:10, let_sino, let_error, 'o:');
axis([0 11 0.03 0.06]);
xlabel('let');
ylabel('MAE');

%%
figure;
hold on;
grid on;
box on;
errorbar(5:5:50, dot_sino, dot_error, 'o:');
axis([0 55 0.030 0.055]);
xlabel('Dot density');
ylabel('MAE');

%%
figure;
hold on;
grid on;
box on;
plot(5:5:50, dot_sino, 'o:');
% axis([0 55 0.030 0.055]);
xlabel('Dot density');
ylabel('MAE');