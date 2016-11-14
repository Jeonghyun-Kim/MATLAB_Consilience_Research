function output = sino_combine(sinogram)
N1 = size(sinogram, 1);
output = NaN(2 * N1, size(sinogram, 2)/2);
N2 = size(output, 2);
output(2 * (1:N1), :) = flip(sinogram(:, (N2 + 1):(2 * N2)));
output(2 * (1:N1) - 1, :) = sinogram(:, 1:N2);
end