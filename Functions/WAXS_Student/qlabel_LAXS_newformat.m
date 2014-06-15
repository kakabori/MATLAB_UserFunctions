%function qlabel_LAXS_newformat(xcen,ycen,lam,sd)
%2/16/07 Thalia Mills
%7/30/07 changed lam and sd for July07 data

% 7/16/09 Yuriy Zubovski
% borrowed WAXS newformat

function qlabel_LAXS_newformat(xcen,ycen,lam,sd)

qz=[2.0,1.8,1.6,1.4,1.2,1.0,0.8,0.6,0.4,0.2,0];
qr=[-2.0:0.1:2.0];
ypixels = -sd * tan( 2* asin( lam*qz/(4*pi) ) ) + xcen;
xpixels = sd * tan( 2* asin( lam*qr/(4*pi) ) ) + ycen;
set(gca,'xtick',xpixels);
set(gca,'ytick',ypixels);
set(gca,'FontSize',14);
set(gca,'yticklabel',qz);
set(gca,'xticklabel',qr);
set(gca,'TickDir','out');
xlabel(' q_r (Å^{-1})','FontSize',16);
ylabel(' q_z (Å^{-1})','FontSize',16);
