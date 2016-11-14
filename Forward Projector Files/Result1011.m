clc;
clear;
%%
close all;

%%
load('0911/0911_shep.mat');

%%
for i = 1:10
    result_ds(i) = MAE_sino(i, 4, 5);
    result_let(i) = MAE_sino(5, i, 5);
    result_dot(i) = MAE_sino(5, 4 ,i);
end

%%
% for i = 1:10
%     result_ds(i) = MAE_fbp(i, 4, 5);
%     result_let(i) = MAE_fbp(5, i, 5);
%     result_dot(i) = MAE_fbp(5, 4 ,i);
% end

%%
figure('position', [500, 500, 700, 480]);
grid on;
hold on;
box on;
set(gca, 'FontSize', 13', 'LineWidth', 1.5);
xlabel('Rebinning factor', 'FontSize', 13);
ylabel('MAE', 'FontSize', 13);
str = {'Dot density : 25', 'Let : 4'};
annotation('textbox',...
    [0.684 0.924 0 0],...
    'String',str,...
    'FontSize',13,...
    'LineWidth',1.5,...
    'FitBoxToText','on');
plot(1:10, result_ds, ['k', 'o-'], 'LineWidth', 1.3);
%%
figure('position', [500, 500, 700, 480]);
grid on;
hold on;
box on;
set(gca, 'FontSize', 13', 'LineWidth', 1.5);
xlabel('Number of source and detector lets', 'FontSize', 13);
ylabel('MAE', 'FontSize', 13);
str = {'Rebinning factor : 5', 'Dot density : 25'};
annotation('textbox',...
    [0.64 0.926 0 0],...
    'String',str,...
    'FontSize',13,...
    'LineWidth',1.5,...
    'FitBoxToText','on');
plot(1:10, result_let, ['k', 'o-'], 'LineWidth', 1.3);
%%
figure('position', [500, 500, 700, 480]);
grid on;
hold on;
box on;
set(gca, 'FontSize', 13', 'LineWidth', 1.5);
xlabel('Dot density', 'FontSize', 13);
ylabel('MAE', 'FontSize', 13);
str = {'Rebinning factor : 5', 'Let : 4'};
annotation('textbox',...
    [0.639 0.925 0 0],...
    'String',str,...
    'FontSize',13,...
    'LineWidth',1.5,...
    'FitBoxToText','on');
plot(5:5:50, result_dot, ['k', 'o-'], 'LineWidth', 1.3);