function result = sino_ellipse(A, rx, ry, x, y, alpha, N, theta, interval, let, offset)
num = N * let;
int = interval/let;
alpha = alpha * pi/180;
temp = NaN(num, length(theta));
result = NaN(N, length(theta));
idx = 0;
i = 1:num;
for rad = theta * pi / 180;
    idx = idx + 1;
    dis = x * cos(rad) + y * sin(rad);
%     ray = (- num/2 + 0.5 + i' - 1 + offset * let) * int;
    ray = (- num/2 + i' - 1 + offset * let) * int;

%     keyboard
    temp(i, idx) = int_ellipse(rx, ry, ray - dis, rad - alpha);
end

for i = 1:N
    result(i, :) = mean(temp((i - 1) * let + 1:i * let, :), 1) * A;
end
end