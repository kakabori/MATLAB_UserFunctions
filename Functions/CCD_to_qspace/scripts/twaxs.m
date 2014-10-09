% Close all figures and clear all variables
close all;
clear;

%% For Windows machine
% Paths to analysis package
addpath(genpath('C:\Documents and Settings\Owner\My Documents\MATLAB_UserFunctions\Functions\CCD_to_qspace'));
% Data
addpath(genpath('C:\Documents and Settings\Owner\My Documents\data\chess11'));

%% For Linux machine
% Path to CCD_to_qspace package
addpath(genpath('/home/kiyo/WinE/MATLAB_UserFunctions/Functions/CCD_to_qspace'));
% Path to slurp function
addpath('/home/kiyo/WinE/MATLAB_UserFunctions/Functions'));
% Data
addpath('/home/kiyo/WinE/MATLAB_UserFunctions/Functions/CCD_to_qspace/data');

% Take care of global variables that are necessary for the transform_ccd2q function
global wavelength pixelSize sDist
wavelength = 1.176;
pixelSize = 0.07113;
sDist = 161.8;

% Load positive and negative angle data
a = slurp('waxs_003_cz.tif', 'c');
b = slurp('bkgd_002_cz.tif', 'c');

% Subtract pedestal from each
a = a - 110;
b = b - 100;

% Scale for an attenuator
b = b * 6.9;

% Subtract the background
tmp = a - b;

% Flip the image so that it looks "normal"
tmp = flipud(tmp);

% Find the horizontal and vertical beam position
beamX = 29;
beamZ = 510;

% Perform the transformtion
twaxs1 = transform_ccd2q(tmp, [0.6 1.8], [-0.6 1], 0.0024, 0.0024, -45, beamX, beamZ);

% Convert floating data points to integer. Otherwise, the image is big, and
% plotting might become slow.
twaxs1.Int = int64(twaxs1.Int);

% Create and save a 2D image
fig1 = figure
qshow(twaxs1, [0 2000]);
axis([1.3 1.7 -0.6 0.6])
saveas(fig1, 'waxs_003.pdf');
%imwrite(Int,filename);

% Create and save qz swaths
figure
[qz, Int] = qzplot_q(twaxs1, [1.483 1.5]);
dlmwrite('twaxs_ripple_qz_strong.dat', [qz Int]);

% Create and save qr swaths
figure
[qr, Int] = qrplot_q(twaxs1, [0.19 0.21]);
dlmwrite('twaxs_ripple_qr_strong.dat', [qr Int]);

% Create and save q swath (sector plot)
figure
[q, Int] = sector_q(twaxs1, [1 2], [5 15]);
dlmwrite('ripple_10deg.dat', [q Int]);

% Create and save phi swath (annular plot)
figure
[phi, Int] = integrate_annulus_q(twaxs1, [0 70], [1.3 1.6]);
dlmwrite('ripple_phi.dat', [phi Int]);
