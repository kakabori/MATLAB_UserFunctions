%function qlabel_WAXS(xcen,ycen,lam,sd)
% 8/8/08 Renamed from qlabel_WAXS to indicate different format choices
% Labels an image in q in angstroms instead of pixels
% Input:
% xcen=X_cen
% ycen=Y_cen
% lam=X_Lambda (x-ray wavelength)
% sd=Spec_to_Phos (sample to detector distance)

%7/26/06 Thalia Mills 
% 3/9/07 modified to also input lam and sd


function qlabel_WAXS_newformat(xcen,ycen,lam,sd)

qx=[1.5;1.0;0.5;0.0];%really, qz
qy=[0:0.2:2];%really, qr
ypixels = -sd * tan( 2* asin( lam*qx/(4*pi) ) ) + xcen;
xpixels = sd * tan( 2* asin( lam*qy/(4*pi) ) ) + ycen;
set(gca,'xtick',xpixels);
set(gca,'ytick',ypixels);
set(gca,'FontSize',12);
set(gca,'yticklabel',[1.5;1.0;0.5;0.0]);
set(gca,'xticklabel',[0;0.2;0.4;0.6;0.8;1.0;1.2;1.4;1.6;1.8;2.0]);
% set(gca,'yticklabel',[0.5;0.4;0.3;0.2;0.1;0]);
% set(gca,'xticklabel',[-0.1;0;0.1]);
set(gca,'TickDir','out');
xlabel(' q_r (Å^{-1})','FontSize',16);
ylabel(' q_z (Å^{-1})','FontSize',16);