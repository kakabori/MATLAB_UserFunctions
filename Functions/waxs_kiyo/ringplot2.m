function ring = ringplot2(imag, p_range, eta_range, d_eta)
%% ring = ringplot2(imag, p_range, eta_range, d_eta)
%This function is similar to integrate_annulus. It returns intensity as a 
%function of eta, which is an angle measured from the meridian, NOT from the 
%equator. The intensity will be averaged over a user-specified range in CCD 
%pixels. The program will interpolate the intensity at a step size given by 
%delta eta.
%
%The required global variables are X_cen and Y_cen.
%
%Use: ring = ringplot2(CCD_image, [500 550], [-5 5], 0.1);
%
%INPUT
% imag -> A matrix variable for the image to be analyzed
%
% p_range -> [pmin pmax], a range in pixels over which intensity on a ring will 
%            be averaged. The range is measured from the beam, i.e., 
%            (pmin+pmax)/2 is the radius of the ring in pixels measured from 
%            the beam.
% 
% eta_range -> [min max], a range in degrees over which a ring curve will be 
%              produced. Note that this angle is defined from the meridian.
%              
% d_eta -> step size in eta. 0.1 works well.
%
%OUTPUT
% ring -> A structure that holds two column vectors named eta and intensity.
%         To access the eta vector, >> ring.eta;
%         To access the intensity vector, >> ring.intensity;
%         To access a specific element, >> ring.eta(i), where i is an intenger

global X_cen Y_cen;

%% Set up the matrices whose elements are the values of p and eta for interpolation.
p = p_range(1):p_range(2);
eta_deg = eta_range(1):d_eta:eta_range(2);
eta = deg2rad(eta_range(1):d_eta:eta_range(2));
len_p = length(p);
len_eta = length(eta);
p2 = repmat(p,[len_eta 1]);
eta2 = repmat(eta',[1 len_p]);

%% Calculate the values of (qr,qz) at which intensity will be interpolated.
x = p2 .* sin(eta2);
y = p2 .* cos(eta2);

px = Y_cen + x;
pz = X_cen - y;

%% Do the interpolation.
I = interp2(imag,px,pz,'spline');

%% Find the points that are outside of the input image.
A = find(px > 1024);
B = find(px < 1);
C = find(pz > 1024);
D = find(pz < 1);
I(A) = 0;
I(B) = 0;
I(C) = 0;
I(D) = 0;

%% Sum intensity along p for each eta and create a column vector, I, as a function of eta
I_eta = sum(I,2)/length(p);

%% Create the output
ring = struct('eta', eta_deg', 'intensity', I_eta);

end
