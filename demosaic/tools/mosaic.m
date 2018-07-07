function [ cfa_image ] = mosaic( rgb_image, cfa_pattern )
%MOSAIC Summary of this function goes here
%   Detailed explanation goes here
    cfa_image = zeros(size(rgb_image,1), size(rgb_image,2));
    start_point = [1, 1; 1, 2; 2, 1; 2, 2];
    for i = 1:4
        cfa_image(start_point(i,1):2:end, start_point(i,2):2:end) = ...
            rgb_image(start_point(i,1):2:end, start_point(i,2):2:end, cfa_pattern(i));
    end
end

