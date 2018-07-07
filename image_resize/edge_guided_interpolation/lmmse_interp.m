function [ output_args ] = lmmse_interp( input_image, scale, sigma1, sigma2 )
%LMMSE_INTERP Summary of this function goes here
%   Detailed explanation goes here
    org_sz = size(input_image);
    half_sz = 2;
    dist = 2*half_sz-1;
    x = -dist:2:dist;
    y = x;
    kernel_sz = size(x,2)/2;
    gauss_kernel_2d = gauss_2d(x, y, sigma1);
    
    % Calculate u_h
    pad_input_image = padarray(input_image,[kernel_sz-1, kernel_sz-1], 'pre');
    pad_input_image = padarray(pad_input_image,[kernel_sz, kernel_sz], 'post');
    ux = conv2(pad_input_image, gauss_kernel_2d, 'valid');
    
    % Calculate sigma_h.
    ux_3d = repmat(ux, 1, 1, kernel_sz);
    temp_array = zeros(org_sz(1), org_sz(2), kernel_sz);
    kernel_1d = gauss_kernel_2d';
    kernel_1d = kernel_1d(:);
    kernel_1d_3d = temp_array;
    idx = 1;
    for r = 1:2:2*dist+1
        for c = 1:2:2*dist+1
            temp_array(:,:,idx) = ((pad_input_image(r:r+org_sz(1)-1,...
                                  c:c+org_sz(2)-1) - ux).^2).*kernel_1d(idx);
            kernel_1d_3d(:,:,idx) = kernel_1d(idx);
            idx = idx + 1;
        end
    end
    sig_h = sum(temp_array,3);
    
end

