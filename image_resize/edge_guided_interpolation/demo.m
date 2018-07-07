clear;
close all;
file_name = '../../temp/data/lena.jpg';

image = imread(file_name);
image = rgb2gray(image);
image = tril(ones(size(image)),0);
figure('name','original image');
imshow(image);

resized_image = ow_interp(image, 'linear');
