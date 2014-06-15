function [ clean_img ] = remove_nan( img )
%This function replaces instances of NaN with 0

%Use the fact that max(NaN, 0) returns 0 to replace instances of  NaN with
%0 and preserve input values elsewhere.
[rows cols] = size(img);
clean_img(1:rows, 1:cols) = max(img(1:rows, 1:cols), 0);
end

