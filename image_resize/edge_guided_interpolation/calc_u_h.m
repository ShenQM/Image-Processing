function [ u_h ] = calc_u_h( input_image,  half_sz, sigma)
%CALC_U_H Summary of this function goes here
%   Detailed explanation goes here
    dist = 2*half_sz-1;
    x = -dist:2:dist;
    y = x;
    kernel_sz = size(x,2)/2;
    gauss_kernel_2d = gauss_2d(x, y, sigma);
    
    % Calculate u_h
    pad_input_image = padarray(input_image,[kernel_sz-1, kernel_sz-1], 'pre');
    pad_input_image = padarray(pad_input_image,[kernel_sz, kernel_sz], 'post');
    u_h = conv2(pad_input_image, gauss_kernel_2d, 'valid');
end

