function [ output_kernel ] = gauss_2d( x, y, sigma )
%GAUSS_2D Summary of this function goes here
%   Detailed explanation goes here
    [X, Y] = meshgrid(x, y);
    output_kernel = exp(-(X.^2+Y.^2)./(sigma.^2)./2);
    % sz = size(output_kernel);
    % output_kernel(sz(1)/2+1, sz(2)/2+1) = 0;
    output_kernel = output_kernel/sum(output_kernel(:));
end

