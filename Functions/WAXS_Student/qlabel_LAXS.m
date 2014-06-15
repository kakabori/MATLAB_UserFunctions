%function qlabel_LAXS(xcen,ycen,lam,sd)
%2/16/07 Thalia Mills
%7/30/07 changed lam and sd for July07 data

function qlabel_LAXS(xcen,ycen,lam,sd)

box on;
%axis([ycen-250 ycen+250 250 1024]);  
%7/30/07 changed to be symmetric about center for each image 

% lam=1.1797;  %July 2007 lam
% sd=5728.0;    %July 2007 Spec_to_Phos
qx=[1.0,0.8,0.6,0.4,0.2,0];
qy=[-.3:.1:0.3];
ypixels = -sd * tan( 2* asin( lam*qx/(4*pi) ) ) + xcen;
xpixels = sd * tan( 2* asin( lam*qy/(4*pi) ) ) + ycen;
set(gca,'xtick',xpixels);
set(gca,'ytick',ypixels);
set(gca,'yticklabel',[1.0;0.8;0.6;0.4;0.2;0]);
set(gca,'xticklabel',[-0.3:0.1:0.3]);
set(gca,'TickDir','out');
set(gca,'FontName','Helvetica');
set(gca,'FontSize',10);
xlabel(' q_r (Å^{-1})');
ylabel(' q_z (Å^{-1})');
set(get(gca,'YLabel'),'FontName','Helvetica');
set(get(gca,'YLabel'),'FontSize',12);
xlabel('q_r (Å^{-1})');
set(get(gca,'XLabel'),'FontName','Helvetica');
set(get(gca,'XLabel'),'FontSize',12);