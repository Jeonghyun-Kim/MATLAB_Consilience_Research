function output = ramp_filter(N, interval)
temp = NaN(1, N - 1);
for i = 1:N-1
    if mod(i, 2) == 0
        temp(i) = 0;
    else
        temp(i) = - 1 / (i * pi * interval)^2;
    end
end
output = [fliplr(temp) (1 / (2 * interval)^2) temp];
end