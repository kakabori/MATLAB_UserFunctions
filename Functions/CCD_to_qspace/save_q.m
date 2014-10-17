% save_q(q_image)
%
% q_image is a q-space stuct, which is output by ccd2q_transform

function save_q(q_image)

% Unpack the struct q_image
qr = q_image.qr;
qz = q_image.qz;
img = q_image.Int;

%% Save input image as a matrix
imwrite(img, 'matrix.dat');

%% Save qr and qz vectors
if isrow(qr)
    qr = qr'
if isrow(qz)
    qz = qz'
dlmwrite('qrqz.dat', [qr qz]);

%% Save as a three-column file for a contour plot in OriginPro
[X, Y] = meshgrid(qr, qz)
Z = img
for k = 1:size(Z, 2)
    tmp_img = [tmp_img; X(:,k) Y(:,k) Z(:,k)];
dlmwrite('column.dat', tmp_img);    
