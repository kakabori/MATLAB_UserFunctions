% Close all figures and clear all variables
close all;
clear;

% Path to CCD_to_qspace package
addpath('/home/kiyo/MATLAB_UserFunctions/Functions/CCD_to_qspace');
% Path to slurp function
addpath('/home/kiyo/MATLAB_UserFunctions/Functions');
% Path to rotateAround function
addpath(genpath('/home/kiyo/MATLAB_UserFunctions/Functions/Downloaded'));
% Data files
addpath(genpath('/home/kiyo/data/chess11'));

% Something we need for show command to work
global MaskD
MaskD = uint8(ones(1024, 1024));

% Experiemntal setup
wavelength = 1.176;
pixelSize = 0.07113;
Sdist = 169.8;

% Load positive and negative angle data
a = load_chess('ripple_060_cz.tif');
b = load_chess('ripple_061_cz.tif');

% Subtract the background
img = a - b;

% Find the horizontal and vertical beam position
beamX = 32;
beamZ = 110;

% Rotate the image to properly align the equator
img = rotateAround(img, beamZ, beamX, 0.97, 'bicubic');

% Set qr and qz ranges
qr_range = [0 1.8];
qz_range = [0 1.0];

% pixel size in q
delta_q = 0.0024;

% incident angle in degrees
omega = 0.2;

% Perform the transformtion
q_img = transform_ccd2q(img, qr_range, qz_range, delta_q, omega, beamX, beamZ, Sdist, wavelength, pixelSize);

% Save the image as ASCII files
save_q(q_img);

% Create and save a 2D image
fig1 = figure;
qshow(q_img, [0 1000]);
%axis([1.3 1.7 0 0.6]);
saveas(fig1, 'ripple.pdf');

% Create and save qz swaths
figure
[qz, Int] = qzplot_q(q_img, [1.483 1.5]);
dlmwrite('ripple_qz.dat', [qz Int]);

% Create and save qr swaths
figure
[qr, Int] = qrplot_q(q_img, [0.19 0.21]);
dlmwrite('ripple_qr.dat', [qr Int]);

% Create and save q swath (radial plot)
figure
[q, Int] = radial_q(q_img, [1 2], [5 15]);
dlmwrite('ripple_10deg.dat', [q Int]);

% Create and save phi swath (annular plot)
figure
[phi, Int] = ring_q(q_img, [0 70], [1.3 1.6]);
dlmwrite('ripple_phi.dat', [phi Int]);

