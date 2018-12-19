function [ bilateral_image ] = imbilateral( image, wsize, sigma_d, sigma_r)
%IMBILATERAL 此处显示有关此函数的摘要
%   此处显示详细说明
    image = double(image);
    %1. Get distance weight
    x = -wsize:wsize;
    y = -wsize:wsize;
    [X,Y] = meshgrid(x, y);
    dist_square = X.^2 + Y.^2;
    dist_square_1d = dist_square';
    dist_square_1d = exp(-dist_square_1d(:)./(2*sigma_d^2));
    dist_weight = repmat(reshape(dist_square_1d,1,1,(2*wsize+1)^2), size(image,1), size(image,2));
    
    %2. Get intensity weight
    pad_image = paddarray_symmetric(image, wsize);
    x = (1:size(image,1)) + wsize;
    y = (1:size(image,2)) + wsize;
    shift_image = zeros(size(image,1), size(image,2), (2*wsize+1)^2);
    intensity_weight = zeros(size(image,1), size(image,2), (2*wsize+1)^2);
    idx_3d = 1;
    for r = -wsize:wsize
        for c = -wsize:wsize
            shift_image(:,:,idx_3d) = pad_image(x+r,y+c);
            intensity_weight(:,:,idx_3d) = exp(-(((pad_image(x+r,y+c) - image).^2) / (2*sigma_r^2)));
            idx_3d = idx_3d+1;
        end
    end
    
    % 3. bilateral filter
    %intensity_weight(:) = 1;
    weight_sum = dot(dist_weight,intensity_weight, 3);
    bilateral_image = dot(dist_weight,intensity_weight.*shift_image, 3);
    bilateral_image = bilateral_image ./ weight_sum;
end

