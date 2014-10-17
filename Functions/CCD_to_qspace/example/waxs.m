% Close all figures and clear all variables
close all;
clear;

% Path to CCD_to_qspace package
addpath('/home/kiyo/MATLAB_UserFunctions/Functions/CCD_to_qspace');
% Path to slurp function
addpath('/home/kiyo/MATLAB_UserFunctions/Functions'));
% Data files
addpath('/home/kiyo/MATLAB_UserFunctions/Functions/CCD_to_qspace/example/data');

% Take care of global variables that are necessary for the transform_ccd2q function
global wavelength pixelSize sDist
wavelength = 1.176;
pixelSize = 0.07113;
sDist = 161.8;

% Load positive and negative angle data
a = load_chess('waxs_003_cz.tif');
b = load_chess('bkgd_002_cz.tif');

% Subtract pedestal from each
a = a - 110;
b = b - 100;

% Scale for an attenuator
b = b * 6.9;

% Subtract the background
img = a - b;

% Find the horizontal and vertical beam position
beamX = 29;
beamZ = 130;

% Set qr and qz ranges
qr_range = [0.6 1.8]
qz_range = [0 1.0]

% pixel size in q
delta_q = 0.0024

% incident angle in degrees
omega = 0.2

% Perform the transformtion
q_img = transform_ccd2q(img, qr_range, qz_range, delta_q, delta_q, omega, beamX, beamZ);

% Save the image as ASCII files
save_q(q_img)

% Create and save a 2D image
fig1 = figure
qshow(q_img, [0 2000]);
axis([1.3 1.7 0 0.6])
saveas(fig1, 'waxs_003.pdf');

% Create and save qz swaths
figure
[qz, Int] = qzplot_q(q_img, [1.483 1.5]);
dlmwrite('twaxs_ripple_qz_strong.dat', [qz Int]);

% Create and save qr swaths
figure
[qr, Int] = qrplot_q(q_img, [0.19 0.21]);
dlmwrite('twaxs_ripple_qr_strong.dat', [qr Int]);

% Create and save q swath (sector plot)
figure
[q, Int] = sector_q(q_img, [1 2], [5 15]);
dlmwrite('ripple_10deg.dat', [q Int]);

% Create and save phi swath (annular plot)
figure
[phi, Int] = integrate_annulus_q(q_img, [0 70], [1.3 1.6]);
dlmwrite('ripple_phi.dat', [phi Int]);
