function result = MakePhantom(A, a, b, x, y, alpha, N, DS_Factor)
x_grid = repmat(linspace(-10, 10, N * DS_Factor), N * DS_Factor, 1);
y_grid = repmat(linspace(10, -10, N * DS_Factor)', 1, N * DS_Factor);
theta = alpha * pi/180; 
cth = cos(theta);
sth = sin(theta);
index = sqrt((((x_grid - x) .* cth + (y_grid - y) .* sth)./a).^2 + ...
    (((x_grid - x) .* (-sth) + (y_grid - y) .* cth)./b).^2) < 1;

temp_image = zeros(N * DS_Factor);

temp_image(index) = A;

if DS_Factor == 1
    result = temp_image;
    return;
end
result = NaN(N);
for i = 1:N
    for j = 1:N
        result(i, j) = mean(mean(temp_image(DS_Factor * (i - 1) + 1:DS_Factor * i, DS_Factor * (j - 1) + 1:DS_Factor * j)));
    end
end
end