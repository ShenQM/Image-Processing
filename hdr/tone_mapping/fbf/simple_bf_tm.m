function [ rgb_out ] = simple_bf_tm( image, out_range, wsize, sigma_s, sigma_r, num_seg, scale )
%SIMPLE_BF_TM 此处显示有关此函数的摘要
%   此处显示详细说明
    intensity = (image(:,:,1)*20 + image(:,:,2)*40 + image(:,:,3))/61;
    r = image(:,:,1)./intensity;
    g = image(:,:,2)./intensity;
    b = image(:,:,3)./intensity;
    
    log_intensity = log10(intensity);
    
%     wsize = 5;
%     sigma_s = 2;
%     sigma_r = 0.12;
%     num_seg = 128;
%     scale = 1;
    
    log_base = fast_bilat( log_intensity, num_seg, wsize, sigma_s, sigma_r, scale );
    %h = fspecial('gaussian', 21, 8);
    %log_base = imfilter(log_intensity, h);
    log_detail = log_intensity - log_base;
    compressfact = log10(out_range)/(max(log_base(:))-min(log_base(:)));
    log_offset = -max(log_base(:)).*compressfact;
    log_out_intensity = log_base.*compressfact + log_offset + log_detail;
    r_out = r.* 10.^(log_out_intensity);
    g_out = g.* 10.^(log_out_intensity);
    b_out = b.* 10.^(log_out_intensity); 
    
    rgb_out = cat(3,r_out,g_out,b_out);
end

