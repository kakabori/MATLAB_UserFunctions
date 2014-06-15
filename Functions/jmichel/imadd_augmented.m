function [ imsum ] = imadd_augmented( img1, img2 )
%This function adds two image matrices with arbitrary dimensions.
%If one matrix has more rows or columns than the other, the sum produced
%by the function will have the greater of the two dimensions. The centers of
%the input matrices are positioned at the center of the output matrix.

img1Class = class(img1);
img2Class = class(img2);

%Ensure the two matrices have the same data type
if(~strcmp(img1Class, img2Class))
    error('Error: The input matrices must be of the same class');
end

%Get the maximum row and column dimension to set the dimensions of the new
%matrix.
[im1rows im1cols] = size(img1);
[im2rows im2cols] = size(img2);
rows = max(im1rows, im2rows);
cols = max(im1cols, im2cols);

%Provide a location for the sum of the two matrices
imsum = zeros(rows, cols, img1Class);

%Find the first and last row and column poisitions to be used in summing the 
%first input matrix and the output matrix such that the first input matrix will 
%be centered within the output matrix.
srow = 1 + floor((rows - im1rows) / 2);
scol = 1 + floor((cols - im1cols) / 2);
erow = srow + im1rows - 1;
ecol = scol + im1cols - 1;
%Add the first matrix to the running sum
imsum(srow:erow, scol:ecol) = imsum(srow:erow, scol:ecol)+img1(1:im1rows,1:im1cols);

%Find the first and last row and column poisitions to be used in summing the 
%second input matrix and the output matrix such that the first input matrix 
%will be centered within the output matrix.
srow = 1 + floor((rows - im2rows) / 2);
scol = 1 + floor((cols - im2cols) / 2);
erow = srow + im2rows - 1;
ecol = scol + im2cols - 1;
%Add the second matrix to the running sum
imsum(srow:erow, scol:ecol) = imsum(srow:erow, scol:ecol)+img2(1:im2rows,1:im2cols);
end

