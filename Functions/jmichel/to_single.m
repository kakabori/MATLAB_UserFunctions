function [ B ] = to_single( A )
%This function casts 32 bit data to single precision floating point numbers.
%This is needed due to the protocol in NFIT to producen TIFF images with
%grayscale values stored in this numerical format.

[rows cols] = size(A);
B = zeros(rows, cols, 'single');
%After allocating a new array, cast its rows to the single precision floating
%point iterpretation of the input data one row at a time.
for i=1:rows
    B(i,1:cols) = typecast(A(i,1:cols), 'single');
end
end

