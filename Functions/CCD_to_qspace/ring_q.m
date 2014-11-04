%[phi I(phi)] = ring_q(imag, phi_range, q_range, bin_size, N_point, q_delta)
%
%This function returns intensity as a function of phi along a constant value
%of q on a q-corrected image. The output will contain two column vectors, 
%phi and I(phi). 
%
%Inputs
%====== 
%imag : Image structure, which is the output from transform_ccd2q function. 
%phi_range : Create plot for this phi range.
%q_range : Integrate intensity over this q range.
%bin_size : size of angular bin in degree.
%N_point : number of interpolation point in phi within each bin.
%q_delta : resolution of interpolation in q in inverse Angstrom.
%



%
%   Inputs  
%       imag -> N*M x-ray scattering image in Cartesian coordinates in q-space.
%       The input image must be an output of transform_ccd2q function so
%       that it follows the specific format defined by KA. See
%       transform_ccd2q.m for the details of the format.
%
%       q_range -> create plot for q_range(1) < q < q_range(2).
%       Units are inverse Angstroms.
%       
%       phi_range -> will integrate intesity for phi_range(1) < phi < phi_range(2).
%       Angles are in degrees and measured counter-clockwise 
%       from the positive equator.
%                    
%       q_delta -> Resolution in q for the plot. Units are inverse Angstroms.
%       
%       phi_delta -> Finess of interpolation in phi. Units are degrees.
%       After interpolation,
%       the program will average the intensity over phi_range. phi_delta
%       should not be much smaller than the resolution of the input image
%       itself.
% 
%   Output 
%       result = [q, I], where both q and I are column vectors. Use these 
%       variables to plot intensity as a function of q in MATLAB.
%
%The program will first transform the input data in 
%Cartensian coordinates into polar coordinates by interpolating within a region 
%specified by q_range and phi_range. Data points will be created at
%every q_delta and phi_delta. 
%Then, the intensity will be averaged over a range specified by phi_range. 
%Data points will finally be created at every q_delta for a range specified 
%by q_range. 
%If no averaging is desired, phi_range(1) should be set equal to phi_range(2).
%
%Caveat: Since the input image will be interpolated, a user should pay
%attention to the resolution of the image and avoid
%interpolating many points between two real data points. The resolution in
%phi is sensitive to the position on the image; very close to the origin,
%phi resolution is very coarse.
%   
function [phi I_phi] = ring_q(img_struct, phi_range, q_range, phi_delta, q_delta)
% Set q_range
if (nargin<3)
    q_range(1) = 1.3;
    q_range(2) = 1.6;
end

% Set the step size of interpolation in phi.
if (nargin<4)
    phi_delta = 0.1;
end

% Set resolution in q
if (nargin<5)
    q_delta = 0.002;
end

qr = img_struct.qr;
qz = img_struct.qz;
qz = qz';
Int = img_struct.Int;
delta_qr = img_struct.delta_qr;
delta_qr = img_struct.delta_qz;

%Set up the matrices whose elements are the values of q and phi for interpolation. 
q = q_range(1):q_delta:q_range(2);
phi = deg2rad(phi_range(1)):deg2rad(phi_delta):deg2rad(phi_range(2));
len_q = length(q);
len_phi = length(phi);
q2 = repmat(q,[len_phi 1]);
phi2 = repmat(phi',[1 len_q]);

%Construct the matrices that will be used as the grid in interpolation.
len_qr=length(qr);
len_qz=length(qz);
qr2=repmat(qr,[len_qz,1]);
qz2=repmat(qz,[1,len_qr]);

%Calculate the values of (qr,qz) at which intensity will be interpolated.
XI = q2 .* cos(phi2);
YI = q2 .* sin(phi2);

%Do the interpolation.
I = interp2(qr2,qz2,double(Int),XI,YI,'spline');

%Find the points that are outside of the input image.
A = find(XI > max(qr));
B = find(XI < min(qr));
C = find(YI > max(qz));
D = find(YI < min(qz));
I(A) = 0;
I(B) = 0;
I(C) = 0;
I(D) = 0;

% Sum intensity along q's for each phi and create a column vector, I, as a
% function of phi
I_phi = sum(I,2)/length(q);

% Create the output consisting of two column vectors.
if isrow(phi)
  phi = phi';
end
if isrow(I_phi)
  I_phi = I_phi';
end

end
