function [ resized_image ] = bilinear_resize( input_image, scaled_size )
%BILINEAR_RESIZE Summary of this function goes here
%   Detailed explanation goes here

    %2 Get all coordinates
    org_sz = [size(input_image,1), size(input_image,2)];
    resized_image = zeros([scaled_size(1), scaled_size(2), size(input_image,3)]);
    delta_scaled = scaled_size - 1;
    delta_org = org_sz - 1;
    x = ((1:scaled_size(2))-1)*delta_org(2)/delta_scaled(2)+1;
    y = ((1:scaled_size(1))-1)*delta_org(1)/delta_scaled(1)+1;
    %x(x<1) = 1;
    %y(y<1) = 1;
    x0 = floor(x);
    x0(end) = size(input_image,2) - 1;
    x1 = x0 + 1;
    %x1(x1>size(input_image,2)) = size(input_image,2);
    y0 = floor(y);
    y0(end) = size(input_image,1) - 1; 
    y1 = y0 + 1;
    %y1(y1>size(input_image,1)) = size(input_image,1);
    
    x = repmat(x, size(input_image,1), 1);
    y = repmat(y', 1, scaled_size(2));
    x0 = repmat(x0, size(input_image,1), 1);
    x1 = repmat(x1, size(input_image,1), 1);
    y0 = repmat(y0', 1, scaled_size(2));
    y1 = repmat(y1', 1, scaled_size(2));
    
    %3 Interploate
    for k_channel = 1:size(input_image, 3)
        %3.1 Interpolate along x axis
        sub_channel = input_image(:,:,k_channel);
        image_x0 = sub_channel(:,x0(1,:));
        image_x1 = sub_channel(:,x1(1,:));
        image_x = ((image_x1-image_x0)./(x1-x0)) .* (x-x0) + image_x0;
        %3.2 Interpolate along y axis
        image_y0 = image_x(y0(:,1),:);
        image_y1 = image_x(y1(:,2),:);
        resized_image = ((image_y1-image_y0)./(y1-y0)) .* (y-y0) + image_y0;
    end
end

