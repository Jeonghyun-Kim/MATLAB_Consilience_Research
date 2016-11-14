function result = DotCountingAnal(A, rx, ry, x0, y0, alpha, dot_interval, ray_interval, ray_num, theta, let)
num = ray_num * let;
ray_interval = ray_interval/let;
temp = NaN(num, length(theta));
result = NaN(ray_num, length(theta));
alpha = alpha * pi/180;
y = repmat(-0.75 * num + dot_interval:dot_interval:0.75 * num, num, 1);
x = repmat((-(num)/2 * ray_interval:ray_interval:(num - 2)/2 * ray_interval)', 1, size(y, 2));
% x = repmat((-(ray_num - 1)/2 * ray_interval:ray_interval:(ray_num - 1)/2 * ray_interval)', 1, size(y, 2));
% keyboard
count = 0;
% keyboard
tic
for rad = theta * pi/180
    count = count + 1;
    y_rot = cos(rad - alpha) * y - sin(rad - alpha) * x;
    x_rot = sin(rad - alpha) * y + cos(rad - alpha) * x;
    index = (x_rot - x0).^2./rx^2 + (y_rot + y0).^2./ry^2 < 1;
    temp(:, count) = sum(index, 2) * dot_interval * A;
end
toc

for i = 1:ray_num
    result(i, :) = mean(temp((i - 1) * let + 1:i * let, :), 1);
end
end