% function result = integrate_annulus(imag, qrange)
%
% Integrate annulus integrates around a ring on a diffraction image.
% The image is specified in - imag
% The inner and outer radii of the diffraction ring as specified by
%           qrange(1) < q < qrange(2)
%
% Integrate_annulus returns Intensity per pixels as a function of angle!
%       result(j,1) = angle in degrees
%       result(j,2) = Mean Intensity in diffraction ring at the angle.
% Angles are measured from the +x cartesian (horizontal).
%
% Relies upon other functions in MOA directory.
% GEST, 8 May, 2005;  modified by TTM and GEST 3/20/06

function result = integrate_annulus(imag, qrange)

% Integration parameters for the un_wrap function
option.radial_bin_minimum=qrange(1);
option.radial_bin_maximum=qrange(2);
option.radial_bin_number=1; 
option.radial_bin_spacing_mode='linear';
option.theta_bin_minimum= pi/2;
option.theta_bin_maximum = pi;
option.theta_bin_number = 90;

% Perform the annular integral using un_wrap
temp = un_wrap(imag,option);

% Convert the results to human-sensible form
Npoints = length(temp.values);
result = temp.theta_values([1:Npoints]) * 180/pi;
%result = [result-90; temp.values];
%result = [-90-result; temp.values];  replace above for May05 CHESS run
%result = result';
%result = [result ; [result(:,1)+360, result(:,2)]];
% Note we are sticky-taping together two rotations.
result = [result-90; temp.values]';

