%function qrplot(imag, rows, options)
%Plots mean intensity v. pixel for rows specified as [r1,r2].
function [temp]=qrplot(img, rows, varargin)

temp = mean(img(rows(1):rows(2), :), 1);

plot(temp, varargin{1:nargin-2});