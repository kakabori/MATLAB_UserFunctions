%Last updated: 2/16/2012
%qzplot_ka 
%  
function [qz, Int3] = qzplot_q(img_struct, qr_range, varargin)
qr = img_struct.qr;
qz = img_struct.qz;
Int = img_struct.Int;
delta_qr = img_struct.delta_qr;
delta_qz = img_struct.delta_qz;

A = find(qr >= qr_range(1) & qr < (qr_range(1)+delta_qz));
B = find(qr >= qr_range(2) & qr < (qr_range(2)+delta_qz));

Int2 = Int(:,A:B);
Int3 = mean(Int2,2);

fprintf('Intensity was integrated from qr=%g A^-1 to qr=%g A^-1,\n',qr(A),qr(B));
fprintf('centered at %g. The number of points averaged is %d.\n',(qr(A)+qr(B))/2, numel(A:B));
plot(qz,Int3,varargin{1:nargin-2});

if isrow(qz)
  qz = qz';
end
if isrow(Int3)
  Int3 = Int3';
end

end
