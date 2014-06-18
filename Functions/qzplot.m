%function ret = qzplot(image, [c1 c2], options)
%Plots mean intensity v. pixel for columns specified as [c1,c2].
%
%Example:
%qzplot(image, [529 531], 'LineStyle', 'none', 'Marker', 'o', 'Color', 'g');
function temp = qzplot(img, columns, varargin)

temp = mean(img(:, columns(1):columns(2)), 2);

plot(temp, varargin{1:nargin-2});