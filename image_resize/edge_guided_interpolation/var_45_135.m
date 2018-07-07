function [ var_45, var_135 ] = var_45_135( input_image, u_h, half_sz, I_45, I_135, method )
%VAR_45_135M Summary of this function goes here
%   Detailed explanation goes here
    org_sz = size(input_image);
    var_45 = zeros(org_sz);
    var_135 = var_45;
    image_45 = zeros(2*org_sz(1), 2*org_sz(2));
    image_135 = image_45;
    image_45(1:2:end,1:2:end) = input_image;
    image_45(2:2:end,2:2:end) = I_45;
    image_135(1:2:end,1:2:end) = input_image;
    image_135(2:2:end,2:2:end) = I_135;
    
    pad_image_45 = padarray(image_45, [half_sz-1,half_sz-1], 'symmetric', 'both');
    pad_image_45 = padarray(pad_image_45, [1,1], 'symmetric', 'post');
    pad_image_135 = padarray(image_135, [half_sz-1,half_sz-1], 'symmetric', 'both');
    pad_image_135 = padarray(pad_image_135, [1,1], 'symmetric', 'post');
    delta_45 = zeros(org_sz(1),org_sz(2),2*half_sz+1);
    delta_135 = delta_45;
    for i = 1:2*half_sz+1
        test = pad_image_135(i:org_sz(1)+i-1, i:org_sz(2)+i-1);
        delta_135(:,:,i) = pad_image_135(i:2:2*org_sz(1)+i-1, i:2:2*org_sz(2)+i-1) - u_h;
        j = 2*half_sz+1 - (i-1);
        test2 = pad_image_45(i:2:2*org_sz(1)+i-1, j:2:j+2*org_sz(2)-1);
        delta_45(:,:,i) = pad_image_45(i:2:2*org_sz(1)+i-1, j:2:j+2*org_sz(2)-1) - u_h;
    end
    
    if strcmp(method, 'abs')
        delta_45 = abs(delta_45);
        delta_135 = abs(delta_135);
        var_45 = (sum(delta_45,3)).^2;
        var_135 = (sum(delta_135,3)).^2;
    end
end

