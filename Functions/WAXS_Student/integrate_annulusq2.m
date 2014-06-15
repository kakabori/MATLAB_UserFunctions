% function result = integrate_annulusq2(imag, qrange)
%
% Integrate annulus integrates around a ring on a diffraction image.
% The image is specified in - imag
% The inner and outer radii of the diffraction ring as specified by
%           qrange(1) < q < qrange(2)
%
% Integrate_annulus returns <Iq^2> as a function of angle!
%       result(j,1) = angle in degrees
%       result(j,2) = Mean value of Intensity*q^2 in diffraction ring at the angle.
% Angles are measured from the +x cartesian (horizontal).
%
% Relies upon other functions in MOA directory.
% GEST, 19 May, 2006

function result = integrate_annulusq2(imag, qrange)

% Integration parameters for the un_wrap function
option.radial_bin_minimum=qrange(1);
option.radial_bin_maximum=qrange(2);
option.radial_bin_number=200; 
option.radial_bin_spacing_mode='linear';
option.theta_bin_minimum= pi/2;
option.theta_bin_maximum = pi;
option.theta_bin_number = 90;

% Perform the annular integral using un_wrap
temp = un_wrap(imag,option);

% Convert the results to human-sensible form
Nq = size(temp.values,1);
Ntheta = size(temp.values,2);
theta = (temp.theta_values([1:Ntheta]) +temp.theta_values([1:Ntheta]+1))/2 * 180/pi - 90;
qvalues = (temp.q_values([1:Nq])+temp.q_values(1+[1:Nq]))/2 ;
Iqs = (qvalues.*qvalues)*temp.values/Nq;

result = [theta; Iqs]';

