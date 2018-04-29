function [ sampled_array ] = sample_rad( h, sampled_sz )
%SAMPLE_RAD Summary of this function goes here
%   Detailed explanation goes here
    x = (0:sampled_sz(2)-1)*h(2);
    y = (0:sampled_sz(1)-1)*h(1);
    [X, Y] = meshgrid(x, y);
    sampled_array = sin(0.5.*(X.^2 + Y.^2));
end

