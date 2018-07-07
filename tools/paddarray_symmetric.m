function [ padded_array ] = paddarray_symmetric( input_array, pad_sz )
%PADDARRAY_SYMMETRIC Pad the array using symmetric method. 
%   Using the board row/column as the symmetry axises.
%   Detailed explanation goes here
    org_sz = size(input_array);
    padded_sz = org_sz + pad_sz + pad_sz;
    padded_array = zeros(padded_sz);
    padded_array(pad_sz+1:pad_sz+org_sz(1),pad_sz+1:pad_sz+org_sz(2)) = input_array;
    
    % add left
    padded_array(:,1:pad_sz) = flip(padded_array(:,pad_sz+2:pad_sz+pad_sz+1),2);
    % add right
    padded_array(:,end-pad_sz+1:end) = flip(padded_array(:,end-pad_sz-pad_sz:end-pad_sz-1),2);
    % add top
    padded_array(1:pad_sz,:) = flip(padded_array(pad_sz+2:pad_sz+pad_sz+1,:),1);
    % add bottom
    padded_array(end-pad_sz+1:end,:) = flip(padded_array(end-pad_sz-pad_sz:end-pad_sz-1,:),1);
end

