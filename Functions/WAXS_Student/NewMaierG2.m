%result = NewMaierG2(param, data)
%no longer uses the Matlab function "mfun", which is not available on the
%student version.

%Instead uses "dawson", a free function downloaded from the following
%website:
% "Complete index of MATLAB utilities"
% http://home.online.no/~pjacklam/matlab/software/util/fullindex.html
% parameters -> Coefficients of the Maier-Saupe fit.
%           param(1) = Iback=constant background.
%           param(2) = A1=scaling factor
%           param(3) = m1=Maier-Saupe parameter.
%           param(4) = A2
%           param(5) = m2

%modified from: 
%function result = MaierG2(param, data)
%    result = param(1) + param(2)/8*exp(-param(3))*sqrt(param(3))/(mfun('dawson', sqrt(param(3))))* exp( 0.5* param(3) * cosd(data) .* cosd(data) ) .* besseli(0,0.5*param(3) * cosd(data) .* cosd(data)) + param(4)/8* exp(-param(5))*sqrt(param(5))/(mfun('dawson', sqrt(param(5)))) * exp( 0.5* param(5) * cosd(data) .* cosd(data) ) .* besseli(0,0.5*param(5) * cosd(data) .* cosd(data));
%           
%
%   data --> phi values on which Maier-Saupe fit equation should be evaluated
%   result --> Intensity of Maier-Saupe fit for each phi.
%   TTM 5/22/06
%  modified 8/14/06 to include normalization with Dawson's integral
% modified 9/19/06 to include 1/8 factor

%12/21/07 (finished 1/2/08) NewMaierG2 created

function result = NewMaierG2(param, data)
    result = param(1) + param(2)/8*exp(-param(3))*sqrt(param(3))/dawson(sqrt(param(3)))* exp( 0.5* param(3) * cosd(data) .* cosd(data) ) .* besseli(0,0.5*param(3) * cosd(data) .* cosd(data)) + param(4)/8* exp(-param(5))*sqrt(param(5))/dawson(sqrt(param(5))) * exp( 0.5* param(5) * cosd(data) .* cosd(data) ) .* besseli(0,0.5*param(5) * cosd(data) .* cosd(data));
    
    
    