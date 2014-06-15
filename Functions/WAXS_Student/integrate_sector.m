% function result = integrate_sector(imag, phi_range, span)
%
%  Integrate image about the point (global variables) X_cen, Y_cen
%  Exclude all points excluded by MaskI and not in the range,
%               phi_range(1) <= phi <= phi_range(2)
%  Where phi is measured counter-clockwise (in degrees) from a +horizontal axis centred on
%  X_cen, Y_cen.
% If span>0,smooths data using the function smooth_data, with moving average and span.
%  If span=0, does not smooth data.
%  
%  Uses the functions sector_mask and integrater.
%
%  GEST, 24 April, 2005.  Modified by TTM 3/21/06 to include smoothing.

function result = integrate_sector(imag, phi_range, span)

global MaskD MaskI 

% Generate mask.
temp_maskD = MaskD; 
temp_maskI = MaskI;
MaskD=MaskI;
MaskI=sector_mask(phi_range);

if (nargin==2)  %sets smoothing span to 0 if none specified.
    span=0;
end

% Do integral
if span==0
result = integrater(imag);
else 
    result=integrater(imag);
    result=smooth_data(result,span);
end

% Restore old Masks.
MaskD=temp_maskD;
MaskI=temp_maskI;
