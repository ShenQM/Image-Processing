%     Copyright (C) 2018 Shen QM
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

%     This is a implement of "High-quality Linear Interpolation for Demosaicing of 
%     Bayer-patterned Color Images".
function [ rgb_image ] = grad_bilinear_demosaic( cfa_image, cfa_pattern )
%GRAD_BILINEAR_DEMOSAIC Summary of this function goes here
%   Detailed explanation goes here
    if isequal(cfa_pattern,[1 2 2 3])
        rgb_image = grad_bilinear_kernel_rggb(cfa_image);
    else
    end
end

function [ rgb_image ] = grad_bilinear_kernel_rggb(cfa_image)
    % 1. Filter.
    kernel_g_rb = [0 0 -1 0 0;
                   0 0 2 0 0;
                   -1 2 4 2 -1;
                   0 0 2 0 0;
                   0 0 -1 0 0] / 8;
   kernel_rb_g_0 = [ 0 0 1/2 0 0;
                     0 -1 0 -1 0;
                     -1 4 5 4 -1;
                     0 -1 0 -1 0;
                     0 0 1/2 0 0] / 8;
   kernel_rb_g_1 = kernel_rb_g_0';
   kernel_rb_br = [ 0 0 -3/2 0 0;
                    0 2 0 2 0;
                    -3/2 0 6 0 -3/2;
                    0 2 0 2 0;
                    0 0 -3/2 0 0] / 8;
   padded_cfa = paddarray_symmetric(cfa_image, 2);
   filter_cfa_g_rb = filter2(kernel_g_rb, padded_cfa, 'valid');
   filter_cfa_rb_g_0 = filter2(kernel_rb_g_0, padded_cfa, 'valid');
   filter_cfa_rb_g_1 = filter2(kernel_rb_g_1, padded_cfa, 'valid');
   filter_cfa_rb_br = filter2(kernel_rb_br, padded_cfa, 'valid');
   
   % 2. Get the rgb image.
   rgb_image = zeros(size(cfa_image,1),size(cfa_image,2),3);
   % g channel
   rgb_image(:,:,2) = cfa_image;
   rgb_image(1:2:end,1:2:end,2) = filter_cfa_g_rb(1:2:end,1:2:end);
   rgb_image(2:2:end,2:2:end,2) = filter_cfa_g_rb(2:2:end,2:2:end);
   % r channel
   rgb_image(:,:,1) = cfa_image;
   rgb_image(1:2:end,2:2:end,1) = filter_cfa_rb_g_0(1:2:end,2:2:end);
   rgb_image(2:2:end,1:2:end,1) = filter_cfa_rb_g_1(2:2:end,1:2:end);
   rgb_image(2:2:end,2:2:end,1) = filter_cfa_rb_br(2:2:end,2:2:end);
   % b channel
   rgb_image(:,:,3) = cfa_image;
   rgb_image(1:2:end,2:2:end,3) = filter_cfa_rb_g_1(1:2:end,2:2:end);
   rgb_image(2:2:end,1:2:end,3) = filter_cfa_rb_g_0(2:2:end,1:2:end);
   rgb_image(1:2:end,1:2:end,3) = filter_cfa_rb_br(1:2:end,1:2:end);
end