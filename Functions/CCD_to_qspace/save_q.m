% save_q(q_image)
%
% q_image is a q-space stuct, which is output by ccd2q_transform

function save_q(q_image)

% Unpack the struct q_image
qr = q_image.qr;
qz = q_image.qz;
img = q_image.Int;

%% Save input image as a matrix
dlmwrite('matrix.dat', img);

%% Save qr and qz vectors
if isrow(qr)
    qr = qr';
end
if isrow(qz)
    qz = qz';
end
dlmwrite('qr.dat', qr);
dlmwrite('qz.dat', qz);

%% Save as a three-column file for a contour plot in OriginPro
[X, Y] = meshgrid(qr, qz);
Z = img;
tmp_img = [];
for k = 1:size(Z, 2)
    tmp_img = [tmp_img; X(:,k) Y(:,k) double(Z(:,k))];
end
dlmwrite('column.dat', tmp_img);    

end
