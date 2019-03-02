dbstop if error;
close all;
file_name = 'data/denoise/lena_noised_gaussian_sigma=20_multi_2.png';
sigma = 20;
k = 0.4;
half_patch_sz = 3;
half_search_sz = 10;

image = imread(file_name);
image_gray = rgb2gray(image);
image_gray = double(image_gray);

image_gray_denoise = nl_mean(image_gray, sigma, k, half_patch_sz, half_search_sz);

figure('name', 'nonlocal mean denoise test');
subplot(1,2,1);
imshow(image_gray/255);
title('original image');

subplot(1,2,2);
imshow(image_gray_denoise/255);
title('denoised image');