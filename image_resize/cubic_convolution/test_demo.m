nth_zero = 23;
sz = [64 64];
h = (sqrt(2*nth_zero*pi) - sqrt(2*(nth_zero-1)*pi)) / 2;
sampled_array = sample_rad([h,h], sz);
figure('Name', 'Orignal array(64x64)');
imshow(sampled_array, [-1, 1]);
imwrite(sampled_array, '../../temp/original_sampled_array_64x64.jpg');

x_max = h*(sz(1)-1);
y_max = x_max;
sz_1 = [336 350];
h_1 = [x_max y_max] ./ (sz_1-1);
org_sampled_array = sample_rad(h_1, sz_1);
figure('Name', 'Original array(350x336)');
imshow(org_sampled_array, [-1, 1]);
imwrite(org_sampled_array, '../../temp/original_array_350x336.jpg');

figure('Name', 'Scale array by nearest(350x336)');
%scaled_array_nearest = imresize(sampled_array, sz_1, 'nearest');
scaled_array_nearest = fast_nn_resize(sampled_array, sz_1);
imshow(scaled_array_nearest, [-1,1]);
imwrite(scaled_array_nearest, '../../temp/scaled_array_nearest_350x336.jpg');

figure('Name', 'Scale array by bilinear(350x336)');
%scaled_array_bilinear = imresize(sampled_array, sz_1, 'bilinear');
scaled_array_bilinear = bilinear_resize(sampled_array, sz_1);
imshow(scaled_array_bilinear, [-1,1]);
imwrite(scaled_array_bilinear, '../../temp/scaled_array_bilinear_350x336.jpg');

scaled_array_cubic_conv = cubic_conv(sampled_array, sz_1);
figure('Name', 'Scaled array cubic convolution(350x336)');
imshow(scaled_array_cubic_conv, [-1, 1]);
imwrite(scaled_array_cubic_conv, '../../temp/scaled_array_cubic_conv_350x336.jpg');

figure('Name', 'Scale array by matlab(350x336)');
scaled_array_matlab = imresize(sampled_array, sz_1, 'cubic');
imshow(scaled_array_matlab, [-1,1]);
imwrite(scaled_array_matlab, '../../temp/scaled_array_matlab_350x336.jpg');

%Compute absolute error
nearest_error = abs(org_sampled_array - scaled_array_nearest);
linear_error = abs(org_sampled_array - scaled_array_bilinear);
cubic_conv_error = abs(org_sampled_array - scaled_array_cubic_conv);
cubic_matlab_error = abs(org_sampled_array - scaled_array_matlab);
max_error = max(linear_error(:))
figure('Name', 'Error compare');
subplot(2,2,1);
imshow(nearest_error, [0, max_error]);
imwrite(nearest_error, '../../temp/nearest_error.jpg')
title('Nearest Error');
subplot(2,2,2);
imshow(linear_error, [0, max_error]);
title('Bilinear Error');
imwrite(linear_error, '../../temp/lineare_error.jpg');
subplot(2,2,3);
imshow(cubic_conv_error, [0, max_error]);
imwrite(cubic_conv_error, '../../temp/cubic_conv_error.jpg');
title('Cubic convolution Error');
subplot(2,2,4);
imshow(cubic_matlab_error, [0, max_error]);
title('Cubic matlab Error');
imwrite(cubic_matlab_error, '../../temp/cubic_matlab_error.jpg');

% x = [1 2 4 8 16 32 64 128; 1 2 4 8 16 32 64 128; 1 2 4 8 16 32 64 128];
% x_conv = cubic_conv(x, [3 16])