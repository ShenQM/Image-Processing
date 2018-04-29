function [ scaled_image ] = cubic_conv( input_image, scaled_sz)
%   CUBIC_CONV  Implement cubic convolution along x direction,
%               then along y direction.
%   input_image Input image.
%   scaled_sz   Size of output image.
%   scaled_image Output image.
    scaled_image_x = cubic_conv_x(input_image, scaled_sz(2));
    scaled_image = cubic_conv_x(scaled_image_x', scaled_sz(1));
    scaled_image = scaled_image';
end

function [ scaled_image_x ] = cubic_conv_x( input_image, scaled_sz_x )
    %1. Compute the coordinates to be interpolated
    org_sz = [size(input_image,1), size(input_image,2)];
    x_org = (0:scaled_sz_x-1)/(scaled_sz_x-1)*(org_sz(2)-1);
    x = zeros([1, scaled_sz_x, 4]);
    x_org_dec = x_org - floor(x_org);
    x(1,:,1) = cubic_kernel(x_org_dec + 1);
    x(1,:,2) = cubic_kernel(x_org_dec);
    x(1,:,3) = cubic_kernel(1 - x_org_dec);
    x(1,:,4) = cubic_kernel(2 - x_org_dec);
    X = repmat(x, org_sz(1), 1, 1);
    
    %2. Compute the boudary data
    col_neg_1 = input_image(:,3) - 3*input_image(:,2) + 3*input_image(:,1);
    col_N_plus_1 = input_image(:,end-2) - 3*input_image(:,end-1) + 3*input_image(:,end);
    extent_image = [col_neg_1, input_image, col_N_plus_1];
    
    x_int = floor(x_org);
    x_int(x_int >= org_sz(2)-1) = org_sz(2)-2;
    % x_int_to_ext_idx = x_int + 1;
    %3. Convolution for the interpolated data
    conv_x = cat(3,extent_image(:,x_int+1), extent_image(:,x_int+2),...
                 extent_image(:,x_int+3), extent_image(:,x_int+4));
    scaled_image_x = dot(X, conv_x, 3);
    scaled_image_x(:,1) = input_image(:,1);
    scaled_image_x(:,end) = input_image(:,end);
end