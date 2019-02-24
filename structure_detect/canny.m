%  Created by  Shen Quanmin on 2019/02/24.
%  Copyright ? 2018 Shen Quanmin. All rights reserved.
function [ edges_res ] = canny(image,kernel_sz, sigma, low_thresh, high_thresh)
%CANNY detect the edge in the image using canny algorithm.
% Main algorithm steps:
% 1. Gaussian filter the image.
% 2. Calculate the intensity of gradient. 
% 3. Non-max suppression for gradient image using gradient direction information;
% 4. Double threshold get weaks edges and strong edges.
% 5. Tracking edges by hysteresis.
% image -- input image.
% kernel_sz -- kernel size used to filter(gauss) the image.
% low_thresh -- low threshold for weak edge(normalized to 1).
% high_thresh -- high threshold for strong edge(normalized to 1).
    debug = 0;
    if isa(image, 'uint8')
        image = double(image)/255;
    elseif isa(image, 'uint16')
        image = double(image)/65535;
    elseif isa(image, 'double')
    else
        error('data type not supported');
    end
    low_thresh = low_thresh*low_thresh;
    high_thresh = high_thresh*high_thresh;
    
    %1. Convert image to gray image
    gray_img = zeros(size(image,1),size(image,2));
    if size(image,3) == 1
        gray_img = image;
    elseif size(image,3) == 3
        gray_img = rgb2gray(image);
    else
        error('Unsupported image format');
    end
    
    %2. Filter the image (denoise using Gaussiaun filter)
    h = fspecial('gaussian', kernel_sz, sigma);
    gray_filt = imfilter(gray_img, h, 'symmetric', 'same');
    if debug
        figure('name', 'gaussian filt image');
        imshow(gray_filt);
    end
    
    %3. Find gradient intensity using sobel kernel
    sx = [-1 0 1;
          -2 0 2;
          -1 0 1];
    sy = [-1 -2 -1;
           0  0  0;
           1  2  1];
    grad_x = imfilter(gray_filt, sx, 'symmetric', 'same', 'corr');
    grad_y = imfilter(gray_filt, sy, 'symmetric', 'same', 'corr');
    grad_intensity = grad_x.*grad_x + grad_y.*grad_y;
    if debug
        figure('name', 'gradient');
        subplot(2,2,1);
        imshow(grad_x);
        title('grad_x');
        subplot(2,2,2);
        imshow(grad_y);
        title('grad_y');
        subplot(2,2,3);
        imshow(grad_intensity);
        title('grad_intensity');
    end
    
    
    %4. Non-maximum suppression
    grad_theta = atan2(grad_y, grad_x);
    grad_direct = grad_theta;
    grad_direct(grad_theta < pi/8 & grad_theta >= -pi/8) = 1;
    grad_direct(grad_theta < 3*pi/8 & grad_theta >= pi/8) = 2;
    grad_direct(grad_theta < 5*pi/8 & grad_theta >= 3*pi/8) = 3;
    grad_direct(grad_theta < 7*pi/8 & grad_theta >= 5*pi/8) = 4;
    grad_direct((grad_theta <= pi & grad_theta >= 7*pi/8) | ...
                (grad_theta < -7*pi/8 & grad_theta >= -pi )) = 5;
    grad_direct(grad_theta < -5*pi/8 & grad_theta >= -7*pi/8) = 6;
    grad_direct(grad_theta < -3*pi/8 & grad_theta >= -5*pi/8) = 7;
    grad_direct(grad_theta < -pi/8 & grad_theta >= -3*pi/8) = 8;
    
    x = 1:size(gray_filt,2);
    y = 1:size(gray_filt,1);
    [X, Y] = meshgrid(x,y);
    X_pos = X;
    X_neg = X;
    Y_pos = Y;
    Y_neg = Y;

    X_pos((grad_direct==1) | (grad_direct==5)) = X((grad_direct==1) | (grad_direct==5))+1;
    X_neg((grad_direct==1) | (grad_direct==5)) = X((grad_direct==1) | (grad_direct==5))-1;
    X_pos((grad_direct==2) | (grad_direct==6)) = X((grad_direct==2) | (grad_direct==6))+1;
    X_neg((grad_direct==2) | (grad_direct==6)) = X((grad_direct==2) | (grad_direct==6))-1;
    X_pos((grad_direct==4) | (grad_direct==8)) = X((grad_direct==4) | (grad_direct==8))+1;
    X_neg((grad_direct==4) | (grad_direct==8)) = X((grad_direct==4) | (grad_direct==8))-1;

    Y_pos((grad_direct==2) | (grad_direct==6)) = Y((grad_direct==2) | (grad_direct==6))+1;
    Y_neg((grad_direct==2) | (grad_direct==6)) = Y((grad_direct==2) | (grad_direct==6))-1;
    Y_pos((grad_direct==3) | (grad_direct==7)) = Y((grad_direct==3) | (grad_direct==7))+1;
    Y_neg((grad_direct==3) | (grad_direct==7)) = Y((grad_direct==3) | (grad_direct==7))-1;
    %Because of the left hand cooridnate, the pos and neg should be
    %reversed.
    Y_pos((grad_direct==4) | (grad_direct==8)) = Y((grad_direct==4) | (grad_direct==8))-1;
    Y_neg((grad_direct==4) | (grad_direct==8)) = Y((grad_direct==4) | (grad_direct==8))+1;
    
    X_pos = clip(X_pos, 1, size(image,2));
    X_neg = clip(X_neg, 1, size(image,2));
    Y_pos = clip(Y_pos, 1, size(image,1));
    Y_neg = clip(Y_neg, 1, size(image,1));
    pos_idx = sub2ind([size(image,1),size(image,2)], Y_pos, X_pos);
    neg_idx = sub2ind([size(image,1),size(image,2)], Y_neg, X_neg);
    grad_non_max_sup = grad_intensity;
    grad_non_max_sup((grad_intensity < grad_intensity(pos_idx) | ...
                     grad_intensity < grad_intensity(neg_idx))) = 0;
    if debug
        figure('name', 'non-max-suppress');
        subplot(1,2,1);
        imshow(grad_intensity);
        title('grad_intensity');
        subplot(1,2,2);
        imshow(grad_non_max_sup);
        title('grad_non_max_sup');
    end
    
    %5. Get edges through double threshold
    edges = zeros(size(image,1), size(image,2));
    edges(grad_non_max_sup > low_thresh) = 2;   %weak edge
    edges(grad_non_max_sup > high_thresh) = 1;  %strong edge
    if debug
        figure('name','all edges');
        imshow(edges);
        title('all edges');
    end
    
    %6. Edge tracking by hysteresis
    strong_edges = edges;
    strong_edges(strong_edges~=1) = 0;
    h = [1 1 1; 1 0 1; 1 1 1];
    strong_edges_filt = imfilter(strong_edges, h, 'symmetric', 'same');
    edges_res = zeros(size(image,1), size(image,2));
    edges_res(abs(edges-1)<1e-9) = 1;
    edges_res((abs(edges-2)<1e-9) & (strong_edges_filt > 0)) = 1;
    if debug
        figure('name','edge detect result');
        subplot(2,2,1);
        imshow(strong_edges);
        title('strong_edges');
        subplot(2,2,2);
        imshow(edges_res);
        title('edges_res');
    end
end

function [ array ] = clip(array, limit_min, limit_max)
%CLIP 此处显示有关此函数的摘要
%   此处显示详细说明
    array(array < limit_min) = limit_min;
    array(array > limit_max) = limit_max;
end

