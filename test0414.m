clear;

image_size = 300;
view = 360;
theta = 0:(360/view):(360 - 360/view);

sinogram = DotCounting(phantom(image_size), 0.1, 1, image_size * 1.5, theta);

figure, imshow(sinogram, []);
%%
% sino = radon(phantom(image_size), theta);
% [ph_FBP2, sino_filter2] = FBP(sino, size(sino, 1), theta, 1, 1, 1, 1/4);
[ph_FBP, sino_filter] = FBP(sinogram, size(sinogram, 1), theta, 1, 1, 1, 1/4);

figure, imshow(ph_FBP, []);