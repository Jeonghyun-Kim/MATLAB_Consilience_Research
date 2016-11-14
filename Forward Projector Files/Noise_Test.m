clear;
avg = 0;
for i = 1:100
    Noise = poissrnd(10^5, [500 500]);
    avg = avg + std2(Noise).^2;
end
avg = avg/100;