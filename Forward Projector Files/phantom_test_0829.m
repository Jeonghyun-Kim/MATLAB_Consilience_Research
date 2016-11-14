clear
clc
%%
shep = [  1   .69   .92    0     0     0   
        -.79 .6624 .8740   0  -.0184   0
        -.2 .1100 .3100  .22    0    -18
        -.2 .1600 .4100 -.22    0     18
         .1 .2100 .2500   0    .35    0
         .1 .0460 .0460   0    .1     0
         .1 .0460 .0460   0   -.1     0
         .1 .0460 .0230 -.08  -.605   0 
         .1 .0230 .0230   0   -.606   0
         .1 .0230 .0460  .06  -.605   0   ];

N = 100;
DS_Factor = 10;
ph = zeros(N);
ph_DS = zeros(N);
for i = 1:size(shep, 1)
%     keyboard
    ph = ph + MakePhantom(shep(i, 1), shep(i, 2) * 10, shep(i, 3) * 10, shep(i, 4) * 10, shep(i, 5) * 10, shep(i, 6), N, 1);
    ph_DS = ph_DS + MakePhantom(shep(i, 1), shep(i, 2) * 10, shep(i, 3) * 10, shep(i, 4) * 10, shep(i, 5) * 10, shep(i, 6), N, DS_Factor);
end
ph_original = phantom(N);
%%
figure;
subplot(1, 3, 1);
imshow(ph_original, []);
title('Original Phantom');
subplot(1, 3, 2);
imshow(ph, []);
title('Custom Phantom');
subplot(1, 3, 3);
imshow(ph_DS, []);
title('Custom Phantom with Down-Sampling');