function [ output_image_h, output_image_v ] = h_v_interp( input_image, mask, method )
%H_V_INTERP Summary of this function goes here
%   Detailed explanation goes here
    org_sz = size(input_image);
    if strcmp(method, 'linear')
        pad_image = padarray(input_image, [1,1],'symmetric', 'both');
        lay_h = zeros(org_sz(1),org_sz(2),2);
        lay_v = lay_h;
        lay_h(:,:,1) = pad_image(2:end-1,1:end-2);
        lay_h(:,:,2) = pad_image(2:end-1,3:end);
        lay_v(:,:,1) = pad_image(1:end-2,2:end-1);
        lay_v(:,:,2) = pad_image(3:end,2:end-1);
        coe = 0.5*ones(org_sz(1),org_sz(2),2);
    elseif strcmp(method, 'cubic_convolution')
        s = [1.5 0.5 -0.5 -1.5];
        kernel = cubic_kernel(s);
        pad_image = padarray(input_image, [2,2], 'both');
        lay_h = zeros(org_sz(1),org_sz(2),4);
        lay_v = lay_h;
        idx = [-2,-1,1,2];
        for i = 1:4
            lay_h(:,:,i) = pad_image(3:end-2,3+idx(i):3+idx(i)+org_sz(2)-1);
            lay_v(:,:,i) = pad_image(3+idx(i):3+idx(i)+org_sz(1)-1,3:end-2);
        end
        coe = zeros(org_sz(1),org_sz(2),4);
        for i = 1:4
            coe(:,:,i) = kernel(i);
        end
    end
        I_h_tmp = dot(lay_h,coe,3);
        I_v_tmp = dot(lay_v,coe,3);
        output_image_h = input_image;
        output_image_v = input_image;
        output_image_h(mask) = I_h_tmp(mask);
        output_image_v(mask) = I_v_tmp(mask);
end

function [ kernel_res ] = cubic_kernel( s )
    kernel_res = zeros(size(s));
    kernel_res(abs(s)<eps) = 1;
    kernel_res(abs(s-1)<eps) = 0;
    kernel_res(abs(s-2)<eps) = 0;
    kernel_res((s>0 & s < 1)) = kernel_0_1(s(s>0 & s < 1));
    kernel_res((s>1 & s < 2)) = kernel_1_2(s(s>1 & s < 2));
end

function [ kernel_res ] = kernel_0_1( s )
    s2 = s.*s;
    s3 = s2.*s;
    kernel_res = 1.5*s3 - 2.5*s2 + 1;
end

function [ kernel_res ] = kernel_1_2( s )
    s2 = s.*s;
    s3 = s2.*s;
    kernel_res = -0.5*s3 + 2.5*s2 - 4*s + 2;
end
