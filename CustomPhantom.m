function result = CustomPhantom(N, DS_Factor)
shep = [  1   .69   .92    0     0     0   
        -.8 .6624 .8740   0  -.0184   0
        -.2 .1100 .3100  .22    0    -18
        -.2 .1600 .4100 -.22    0     18
         .1 .2100 .2500   0    .35    0
         .1 .0460 .0460   0    .1     0
         .1 .0460 .0460   0   -.1     0
         .1 .0460 .0230 -.08  -.605   0 
         .1 .0230 .0230   0   -.606   0
         .1 .0230 .0460  .06  -.605   0   ];
result = zeros(N);
for i = 1:size(shep, 1)
    result = result + MakePhantom(shep(i, 1), shep(i, 2) * 10, shep(i, 3) * 10, ...
        shep(i, 4) * 10, shep(i, 5) * 10, shep(i, 6), N, DS_Factor);
end
end