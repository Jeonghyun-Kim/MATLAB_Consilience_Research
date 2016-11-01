function [output, sino_filter] = FBP(sinogram, N, theta, interval, pixel_amplifier, ft_size, offset)
%% Ramp Filter Implementation
sino_filter = interval * convn(sinogram, ramp_filter(N, interval)');

%% Linear Interpolation & Back Projection
view = length(theta);
SINO_AXIS = ((- 3/2 * N + 1.5):1/ft_size:(3/2 * N - 1.5) + 1 - 1/ft_size) * interval + offset;
output = zeros(N);
interval = interval / pixel_amplifier;
X = repmat((- N/2 + 0.5) * interval:interval:(N/2 - 0.5) * interval, N, 1);
Y = repmat(((N/2 - 0.5) * interval:-interval:(- N/2 + 0.5) * interval)', 1, N);
idx = 1;
for th = theta * pi / 180
    output = output + interp1(SINO_AXIS, interpft(sino_filter(:, idx)', length(sino_filter(:, idx)') * ft_size), Y .* sin(th) + X .* cos(th), 'linear');
%     output = output + interp1(SINO_AXIS, sino_filter(:, idx)', Y .* sin(th) + X .* cos(th), 'linear');
    idx = idx + 1;
end
output = output * pi / view;
end