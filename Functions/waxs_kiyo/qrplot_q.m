%Last updated: 2/16/2012
%qrplot_ka 
%   
function [qr, Int3] = qrplot_q(img_struct, qz_range, varargin)
qr = img_struct.qr;
qz = img_struct.qz;
Int = img_struct.Int;
delta_qr = img_struct.delta_qr;
delta_qz = img_struct.delta_qz;

A = find(qz >= qz_range(1) & qz < (qz_range(1)+delta_qr));
B = find(qz >= qz_range(2) & qz < (qz_range(2)+delta_qr));

Int2 = Int(A:B,:);
Int3 = mean(Int2,1);

fprintf('Intensity was integrated from qz=%g A^-1 to qz=%g A^-1,\n',qz(A),qz(B));
fprintf('centered at %g. The number of points averaged is %d.\n',(qz(A)+qz(B))/2, numel(A:B));
plot(qr,Int3,varargin{1:nargin-2});
end

