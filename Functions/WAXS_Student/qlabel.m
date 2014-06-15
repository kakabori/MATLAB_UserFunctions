%function qlabel(xcen,ycen,lam,sd)
%7/26/06 Thalia Mills 
% 3/9/07 modified to also input lam and sd
function qlabel(xcen,ycen,lam,sd)

qx=[2.0,1.5,1,0.5,0];
qy=[0:0.5:2.0];
% qx=[0.5,0.4,0.3,0.2,0.1,0];
% qy=[-0.1:0.1:0.1];
ypixels = -sd * tan( 2* asin( lam*qx/(4*pi) ) ) + xcen;
xpixels = sd * tan( 2* asin( lam*qy/(4*pi) ) ) + ycen;
set(gca,'xtick',xpixels);
set(gca,'ytick',ypixels);
% set(gca,'yticklabel',[2.0;1.5;1.0;0.5;0]);
% set(gca,'xticklabel',[0;0.5;1.0;1.5;2.0]);
set(gca,'yticklabel',[0.5;0.4;0.3;0.2;0.1;0]);
set(gca,'xticklabel',[-0.1;0;0.1]);
set(gca,'TickDir','out');
xlabel(' q_r (A^{-1})');
ylabel(' q_z (A^{-1})');