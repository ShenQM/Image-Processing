%  Created by  Shen Quanmin on 2019/02/24.
%  Copyright ? 2018 Shen Quanmin. All rights reserved.
%  Reference articles:
%  1. Antoni Buades, etc. A non-local algorithms for image denoising. 2005
%  2. Antoni Buades, etc. Non-Local Means Denoising. 2011
%  (http://dx.doi.org/10.5201/ipol.2011.bcm_nlm)
function [ res_image ] = nl_mean(image, sigma, k, half_patch_sz, half_search_sz)
%NL_MEAN nonlocal mean denoising algorithm implementation.
%   image -- input image.
%   sigma -- input image noise variance.
%   k -- input factor to calculate h for denoising.
%   half_patch_sz -- half size of block to find similar patches.
%   half_search_sz -- half size of the search window.
    if size(image,3) > 1
        error('Only support gray image');
    end

    Ss = half_search_sz;
    Ps = half_patch_sz;
    Pnum = (2*Ps+1)^2;
    [w,h] = size(image);
    pad_image = paddarray_symmetric(image, Ps+Ss);

    sigma22 = sigma*sigma;
    h2 = k*k*sigma22;
    
    ref_image = pad_image(1+Ss:h+2*Ps+Ss, 1+Ss:w+2*Ps+Ss);
    weight_sum = zeros([w,h]);
    res_image = zeros([w,h]);
    
    for r = -Ss:Ss
        for c = -Ss:Ss
            %1. Get cumsum of the difference image.
            diff = pad_image(1+Ss+r:h+2*Ps+Ss+r,1+Ss+c:w+2*Ps+Ss+c) - ref_image;
            diff2 = diff .^ 2;
            cumsum_diff2 = cumsum(diff2, 1);
            cumsum_diff2 = cumsum(cumsum_diff2, 2);
            pad_cum_diff2 = padarray(cumsum_diff2, [1,1], 0, 'pre');
            %2. Get weight of every patch.
            block_diff_sum2 = pad_cum_diff2(2+2*Ps:end,2+2*Ps:end) + ...
                             pad_cum_diff2(1:end-2*Ps-1,1:end-2*Ps-1) - ...
                             pad_cum_diff2(2+2*Ps:end,1:end-2*Ps-1) - ...
                             pad_cum_diff2(1:end-2*Ps-1,2+2*Ps:end);
            dist = block_diff_sum2 ./ Pnum;
            weight = exp(-max(dist-sigma22, 0)./h2);
            weight_sum = weight_sum + weight;
            %3. Add weighted image.
            res_image = res_image + weight .* pad_image(1+Ps+Ss+r:Ps+Ss+r+h,...
                        1+Ps+Ss+c:Ps+Ss+c+w);
        end
    end
    %4. Get denoised image.
    res_image = res_image ./ weight_sum;
end

%% Algorithm steps
% 1. For every pixel, compute the patch distances d with the reference patch.
% 2. According these distances, get these weights w =
%    exp(-max(d-2*sigma2,0)/h2).
% 3. Aggregate the corresponding pixel values with weights w.

% Advantages:
% 1. Use the spatial local similarity of images with geometrical
%    configuration.
% 2. Compare to spatial filter, it can preserve local texture.
