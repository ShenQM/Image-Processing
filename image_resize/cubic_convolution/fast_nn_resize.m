function [ resized_image ] = fast_nn_resize( input_image,  scaled_size)
%FAST_NN_RESIZE Neareast algorithm for image resize use vector operation.
%   input_image   -- Image to be resized.
%   scale         -- Resize factor.
%   resized_image -- Resized image.

    %2. Get the coordinates of reized image pixels in the original 
    org_sz = [size(input_image,1), size(input_image,2)];
    resized_image = zeros([scaled_size(1), scaled_size(2), size(input_image,3)]);
    delta_scaled = scaled_size - 1;
    delta_org = org_sz - 1;
    r_idx = round(((1:scaled_size(1))-1)*delta_org(1)/delta_scaled(1)+1);
    c_idx = round(((1:scaled_size(2))-1)*delta_org(2)/delta_scaled(2)+1);
    %r_idx(r_idx < 1) = 1;
    %c_idx(c_idx < 1) = 1;
    r_idx = repmat(r_idx', 1, scaled_size(2));
    c_idx = repmat(c_idx, scaled_size(1), 1);
    idx = (c_idx-1)*size(input_image,1) + r_idx;
    
    %3. Get the scaled image
    for k_channel = 1:size(input_image,3)
        sub_channel = input_image(:,:,k_channel);
        resized_image(:,:,k_channel) = sub_channel(idx);
    end
end

