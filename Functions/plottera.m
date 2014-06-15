% function handle=plottera( x, offset, options)
%
% Kludge of plot command in matlab.
% x(:,1) is the x-coordinate.
% x(:,2) is the y-coordinate.
% options is a string of options for plotting as used in MATLAB
% plots graph on current figure and returns line handle, just like plot.
% modified 11/13/06 by TTM to include offset- adds constant offset to the intensity

function handle=plottera(x,offset,options)

if (nargin>2)
   handle = plot(x(:,1),x(:,2)+offset,options);
else
   handle=plot(x(:,1),x(:,2)+offset);
end

xlabel('{\it\phi} (deg)');    %changed 9/19/06 to show phi symbol
ylabel('Intensity (arb.)');
