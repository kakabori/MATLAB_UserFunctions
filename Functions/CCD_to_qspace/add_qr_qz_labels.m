function add_qr_qz_labels(qr, qz, wavelength, beamX, beamZ, sDist, pixelSize)
%add_qr_qz_labels(qr, qz, wavelength, beamX, beamZ, sDist) 
%
%This function adds qr and qz labels to the current figure using a small
%angle approximation.
%
%Example:
%>> add_qr_qz_labels(0:0.1:1, [0.2 0.3 0.8], 1.175, 522, 948, 359.3);
%will create labels at qr = 0, 0.1, 0.2, ..., 1 and qz = 0.2, 0.3, and 0.8.
%
%A user must supply qr and qz row vectors which contain qr and qz values
%at which tick marks and labels will be placed. These vectors must be
%monotonically increasing order, but the increments do not have to be 
%the same throughout the vectors. Note that pixels and q values are assumed
%to be linearly proportional to each other. In other words, the low angle
%scattering is assumed. For wide angle scattering, see transform_ccd2q.m.
%
%beamX: horizontal beam position 
%beamZ: vertical beam position
%These two variables are in matrix column row position, unlike tview.
%To find the beam positions, simply display an X-ray data with imagesc command,
%and find the X (beamX) and Y (beamZ) values of the beam center.
%
%wavelength: X-ray wavelength
%sDist: sample to detector distance
%pixelSize: pixel size of the CCD detector

sDist = sDist / pixelSize;
qz = fliplr(qz);
theta = asin(wavelength * qr / 4 /pi);
px = beamX + sDist * tan(2*theta);
theta = asin(wavelength * qz / 4 /pi);
pz = beamZ - sDist * tan(2*theta);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);
set(gca, 'xtick', px);
set(gca, 'ytick', pz);
set(gca, 'xticklabel', qr);
set(gca, 'yticklabel', qz);
set(gca, 'TickDir', 'out');
xlabel(strcat('q_r (', char(197), '^{-1})'), 'interpreter', 'tex', 'FontName', 'Times New Roman');
ylabel(strcat('q_z (', char(197), '^{-1})'), 'interpreter', 'tex', 'FontName', 'Times New Roman');
end

