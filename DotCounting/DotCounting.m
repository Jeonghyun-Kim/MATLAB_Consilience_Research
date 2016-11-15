function result = DotCounting(image, dot_interval, ray_interval, ray_num, theta, let)
num = ray_num * let;
ray_interval = ray_interval/let;
temp = NaN(num, length(theta));
result = NaN(ray_num, length(theta));
image_spacing = zeros(3 * size(image));
[H, W] = size(image);
centerH = size(image_spacing, 1)/2;
centerW = size(image_spacing, 2)/2;
image_spacing(centerH - H/2 + 1:centerH + H/2, centerW - W/2 + 1:centerW + W/2) = image;
% x = repmat(linspace(centerH - 0.75 * H + dot_interval/2, centerH + 0.75 * H - dot_interval/2, 1.5 * H / dot_interval), num, 1);
x = repmat(centerH - 0.75 * H + dot_interval:dot_interval:centerH + 0.75 * H, num, 1);
% y = repmat((linspace(centerW - (num - 1)/2 * ray_interval, centerW + (num - 1)/2 * ray_interval, num))', 1, size(x, 2));
y = repmat((centerW - (num/2 - 1) * ray_interval:ray_interval:centerW + num/2 * ray_interval)', 1, size(x, 2));

% keyboard
count = 0;
% tic
centerW = centerW + 1/2;
centerH = centerH + 1/2;
for rad = theta * pi/180
    count = count + 1;
    x_rot = cos(rad) * (x - centerH) - sin(rad) * (y - centerW) + centerH;
    y_rot = sin(rad) * (x - centerH) + cos(rad) * (y - centerW) + centerW;
%     keyboard
    temp(:, count) = sum(image_spacing(size(image_spacing, 1) * (round(y_rot) - 1) + round(x_rot)), 2) * dot_interval * 20/length(image);
end
% toc

for i = 1:ray_num
    result(i, :) = mean(temp((i - 1) * let + 1:i * let, :), 1);
end
end