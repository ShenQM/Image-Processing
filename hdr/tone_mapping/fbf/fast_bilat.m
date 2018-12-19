function [ J ] = fast_bilat( image, num_seg, wsize, sigma_s, sigma_r, scale )
%FAST_BILAT 此处显示有关此函数的摘要
%   此处显示详细说明
    image = double(image);
    wsize = round(wsize*scale);
    
    %1. Get distance weight
    x = -wsize:wsize;
    y = -wsize:wsize;
    [X,Y] = meshgrid(x, y);
    spatial_kernel = exp(-(X.^2 + Y.^2)./(2*sigma_s^2));
    
    max_intensity = max(image(:));
    min_intensity = min(image(:));
    segment = (max_intensity - min_intensity) / num_seg;
    I_ = imresize(image, scale);
    
    pad_image_ = paddarray_symmetric(I_, wsize);
    J = zeros(size(image));
    for i = 0:num_seg
        i_j = min_intensity + i*segment;
        G_j = exp(-((pad_image_ - i_j).^2)./(2*sigma_r^2));
        k_ = filter2(spatial_kernel, G_j, 'valid');
        H_j = G_j .* pad_image_;
        H_j_ = filter2(spatial_kernel, H_j,  'valid');
        J_j = H_j_ ./ k_;
        J_j_ = imresize(J_j,size(image));
        
        delta_I = abs(image - i_j);
        delta_I(delta_I>segment) = segment;
        delta_I = 1 - delta_I/segment;
        J = J + J_j_ .* delta_I;
    end
end

