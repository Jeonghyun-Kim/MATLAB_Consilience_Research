clc;
clear;

%%
N = 200;
DS_Factor = 10;

%%
ph = CustomPhantom(N, 1);
ph_DS = CustomPhantom(N, DS_Factor);

%%
figure, imshow(ph, []);
figure, imshow(ph_DS, []);