function [ demosaiced_img ] = demosaic_bilinear( cfa_image, cfa_pattern )
%DEMOSAIC_BILINEAR Summary of this function goes here
%   Detailed explanation goes here
    demosaiced_img = zeros(size(cfa_image,1), size(cfa_image, 2), 3);
    demosaiced_img(:,:,2) = calc_g_channel(cfa_image,cfa_pattern);
    [demosaiced_img(:,:,1),demosaiced_img(:,:,3)] = ...
        calc_rb_channel(cfa_image, cfa_pattern);
end

function [ g_channel ] = calc_g_channel(cfa_image, cfa_pattern)
    kernel = [0 1/4 0; 1/4 0 1/4; 0 1/4 0];
    padded_cfa_image = zeros(size(cfa_image,1)+2,size(cfa_image,2)+2);
    padded_cfa_image(2:end-1,2:end-1) = cfa_image;
    padded_cfa_image(2:end-1,1) = padded_cfa_image(2:end-1,3);
    padded_cfa_image(2:end-1,end) = padded_cfa_image(2:end-1,end-2);
    padded_cfa_image(1,:) = padded_cfa_image(3,:);
    padded_cfa_image(end,:) = padded_cfa_image(end-2,:);
    filtered_cfa = filter2(kernel, padded_cfa_image, 'valid');
    
    g_channel = cfa_image;
    if cfa_pattern(1) == 2 && cfa_pattern(4) == 2
        g_channel(1:2:end,2:2:end) = filtered_cfa(1:2:end,2:2:end);
        g_channel(2:2:end,1:2:end) = filtered_cfa(2:2:end,1:2:end);
    elseif cfa_pattern(2) == 2 && cfa_pattern(3) == 2
        g_channel(1:2:end,1:2:end) = filtered_cfa(1:2:end,1:2:end);
        g_channel(2:2:end,2:2:end) = filtered_cfa(2:2:end,2:2:end);
    end
end

function [ r_channel, b_channel ] = calc_rb_channel(cfa_image, cfa_pattern)
    kernel_v = [0 1/2 0; 0 0 0; 0 1/2 0];
    kernel_h = [0 0 0; 1/2 0 1/2; 0 0 0];
    kernel_d = [1/4 0 1/4; 0 0 0; 1/4 0 1/4];
    
    padded_cfa_image = zeros(size(cfa_image,1)+2,size(cfa_image,2)+2);
    padded_cfa_image(2:end-1,2:end-1) = cfa_image;
    padded_cfa_image(2:end-1,1) = padded_cfa_image(2:end-1,3);
    padded_cfa_image(2:end-1,end) = padded_cfa_image(2:end-1,end-2);
    padded_cfa_image(1,:) = padded_cfa_image(3,:);
    padded_cfa_image(end,:) = padded_cfa_image(end-2,:);
    
    filtered_v = filter2(kernel_v, padded_cfa_image, 'valid');
    filtered_h = filter2(kernel_h, padded_cfa_image, 'valid');
    filtered_d = filter2(kernel_d, padded_cfa_image, 'valid');
    
    r_channel = cfa_image;
    b_channel = r_channel;
    if cfa_pattern(1) == 2 && cfa_pattern(4) == 2
        if cfa_pattern(2) == 3 && cfa_pattern(3) == 1
            b_channel(1:2:end,1:2:end) = filtered_h(1:2:end,1:2:end);
            b_channel(2:2:end,2:2:end) = filtered_v(2:2:end,2:2:end);
            b_channel(2:2:end,1:2:end) = filtered_d(2:2:end,1:2:end);
            r_channel(1:2:end,1:2:end) = filtered_v(1:2:end,1:2:end);
            r_channel(1:2:end,2:2:end) = filtered_d(1:2:end,2:2:end);
            r_channel(2:2:end,2:2:end) = filtered_h(2:2:end,2:2:end);
        else
            r_channel(1:2:end,1:2:end) = filtered_h(1:2:end,1:2:end);
            r_channel(2:2:end,2:2:end) = filtered_v(2:2:end,2:2:end);
            r_channel(2:2:end,1:2:end) = filtered_d(2:2:end,1:2:end);
            b_channel(1:2:end,1:2:end) = filtered_v(1:2:end,1:2:end);
            b_channel(1:2:end,2:2:end) = filtered_d(1:2:end,2:2:end);
            b_channel(2:2:end,2:2:end) = filtered_h(2:2:end,2:2:end);
        end
    elseif cfa_pattern(2) == 2 && cfa_pattern(3) == 2
        if cfa_pattern(1) == 1 && cfa_pattern(4) == 3
            r_channel(1:2:end,2:2:end) = filtered_h(1:2:end,2:2:end);
            r_channel(2:2:end,1:2:end) = filtered_v(2:2:end,1:2:end);
            r_channel(2:2:end,2:2:end) = filtered_d(2:2:end,2:2:end);
            b_channel(1:2:end,1:2:end) = filtered_d(1:2:end,1:2:end);
            b_channel(1:2:end,2:2:end) = filtered_v(1:2:end,2:2:end);
            b_channel(2:2:end,1:2:end) = filtered_h(2:2:end,1:2:end);
        else
            b_channel(1:2:end,2:2:end) = filtered_h(1:2:end,2:2:end);
            b_channel(2:2:end,1:2:end) = filtered_v(2:2:end,1:2:end);
            b_channel(2:2:end,2:2:end) = filtered_d(2:2:end,2:2:end);
            r_channel(1:2:end,1:2:end) = filtered_d(1:2:end,1:2:end);
            r_channel(1:2:end,2:2:end) = filtered_v(1:2:end,2:2:end);
            r_channel(2:2:end,1:2:end) = filtered_h(2:2:end,1:2:end);
        end
    end
end