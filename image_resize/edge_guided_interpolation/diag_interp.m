function [ I_45, I_135 ] = diag_interp( input_image, method )
%DIAG_INTERP Summary of this function goes here
%   Detailed explanation goes here
    I_45 = zeros(size(input_image));
    I_135 = I_45;
    if strcmp(method, 'linear')
        pad_image = padarray(input_image, [1, 1], 'symmetric', 'post');
        kernel_45 = [0, 0.5; 0.5, 0];
        kernel_135 = [0.5 0; 0, 0.5];
        I_45 = conv2(pad_image, kernel_45,  'valid');
        I_135 = conv2(pad_image, kernel_135, 'valid');
    elseif strcmp(method, 'cubic_convolution')
        org_sz = size(input_image);
        s = [1.5 0.5 -0.5 -1.5];
        kernel = cubic_kernel(s);
        % Calculate I_135
        pad_image = padarray(input_image, [1, 1], 'symmetric', 'pre');
        pad_image = padarray(pad_image, [2, 2], 'symmetric', 'post');
        image_3d_135 = zeros(org_sz(1),org_sz(2),4);
        image_3d_45 = image_3d_135;
        image_3d_135(:,:,1) = pad_image(1:org_sz(1),1:org_sz(2))*kernel(1);
        image_3d_135(:,:,2) = pad_image(2:org_sz(1)+1,2:org_sz(2)+1)*kernel(2);
        image_3d_135(:,:,3) = pad_image(3:org_sz(1)+2,3:org_sz(2)+2)*kernel(3);
        image_3d_135(:,:,4) = pad_image(4:org_sz(1)+3,4:org_sz(2)+3)*kernel(4);
        
%         image_3d_135 = [pad_image(1:org_sz(1),1:org_sz(2))*kernel(1), pad_image(2:org_sz(1)+1,2:org_sz(2)+1)*kernel(2), ...
%                        pad_image(3:org_sz(1)+2,3:org_sz(2)+2)*kernel(3), pad_image(4:org_sz(1)+3,4:org_sz(2)+3)*kernel(4)];
        I_135 = sum(image_3d_135,3);
        % Calculate I_45
        image_3d_45(:,:,1) = pad_image(1:org_sz(1),4:org_sz(2)+3)*kernel(1);
        image_3d_45(:,:,2) = pad_image(2:org_sz(1)+1,3:org_sz(2)+2)*kernel(2);
        image_3d_45(:,:,3) = pad_image(3:org_sz(1)+2,2:org_sz(2)+1)*kernel(3);
        image_3d_45(:,:,4) = pad_image(4:org_sz(1)+3,1:org_sz(2))*kernel(4);
%         image_3d_45 = [pad_image(1:org_sz(1),4:org_sz(2)+3)*kernel(1), pad_image(2:org_sz(1)+1,3:org_sz(2)+2)*kernel(2), ...
%                        pad_image(3:org_sz(1)+2,2:org_sz(2)+1)*kernel(3), pad_image(4:org_sz(1)+3,1:org_sz(2))*kernel(4)];
        I_45 = sum(image_3d_45,3);
    end
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

