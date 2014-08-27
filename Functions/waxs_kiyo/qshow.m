%Last updated: 7/16/2012 by KA
%qshow(struct, color_scale)
%
%Example:
%qshow(2D_qspace_image, [0 3000]);
%
%This function plots 2D intensity map in q-space. The input struct is 
%normally an output from transform_ccd2q function.
%
%struct: must have a struct that has qr and qz vectors and Int matrix.
%numel(Int) = numel(qr) * numel(qz)

function qshow(struct, color_scale)
%set(gcf, 'defaulttextinterpreter', 'latex');
imagesc(struct.qr, struct.qz, struct.Int, color_scale);
colormap(gray); axis image; axis xy; %axis([1.3 2.0 0 0.5]);

% Notation. [a:b:c] means tick marks will be placed between a and c with an
% increment of b. For example, [-1:0.5:1] will generate marks at -1, -0.5,
% 0, 0.5, and 1.
set(gca,'xtick',min(struct.qr):0.1:max(struct.qr));
set(gca,'ytick',min(struct.qz):0.1:max(struct.qz));
set(gca,'xticklabel',min(struct.qr):0.1:max(struct.qr));
set(gca,'yticklabel',min(struct.qz):0.1:max(struct.qz));
set(gca,'tickdir','out');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'FontSize', 16);
set(gca, 'FontName', 'Times New Roman');
%xlabel(strcat('q_r (', char(197), '^{-1})'), 'interpreter', 'tex');
%ylabel(strcat('q_z (', char(197), '^{-1})'), 'interpreter', 'tex');
end

