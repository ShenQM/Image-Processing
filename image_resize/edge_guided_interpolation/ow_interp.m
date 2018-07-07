function [ output_image ] = ow_interp( input_image, method )
    quart_1 = ow_interp_kernel_45_135(input_image, method);
    figure('name','image_45_135');
    imshow(quart_1,[]);
    
    out_image = zeros(2*size(input_image));
    out_image(1:2:end,1:2:end) = input_image;
    out_image(2:2:end,2:2:end) = quart_1;
    ow_interp_kernel_h_v(out_image, method);
end
function [ output_image ] = ow_interp_kernel_45_135( input_image, method )
%OW_INTER Summary of this function goes here
%   Detailed explanation goes here
    [I_45, I_135] = diag_interp(input_image, method);
    figure('name','I_45 image');
    imshow(I_45,[]);
    figure('name','I_135 image');
    imshow(I_135,[]);
    
    u_h = calc_u_h(input_image, 1, 1);
    figure('name','u_h');
    imshow(u_h,[]);    
    
    [var_45, var_135] = var_45_135(input_image, u_h, 2, I_45, I_135, 'abs');
    figure('name','var_45');
    imshow(var_45,[]);    
    figure('name','var_135');
    imshow(var_135,[]);
    
    var_45 = var_45 + eps;
    var_135 = var_135 + eps;
    w_45 = var_45./(var_45+var_135);
    w_135 = 1 - w_45;
    output_image = w_45.*I_45 + w_135.*I_135;
end

function [output_image] = ow_interp_kernel_h_v(input_image, method)
    figure('name','input_image');
    imshow(input_image,[]);
    mask = zeros(size(input_image));
    mask(1:2:end,2:2:end) = 1;
    mask(2:2:end,1:2:end) = 1;
    mask = logical(mask);
    [I_h, I_v] = h_v_interp(input_image, mask, method);
    figure('name','I_h image');
    imshow(I_h,[]);
    figure('name','I_v image');
    imshow(I_v,[]);
end

