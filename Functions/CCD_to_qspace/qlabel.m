function qlabel
%% function qlabel
%
%

%% Parse global variables
global X_cen Y_cen X_Lambda Spec_to_Phos

%% Set up labels
qz=[2.0:-0.1:0];
qr=[-2.0:0.1:2.0];
qz2=[2.0:-0.2:0];
qr2=[-2.0:0.2:2.0];

%% 
ypixels = -Spec_to_Phos * tan( 2* asin( X_Lambda*qz/(4*pi) ) ) + X_cen;
xpixels = Spec_to_Phos * tan( 2* asin( X_Lambda*qr/(4*pi) ) ) + Y_cen;
set(gca,'XMinorTick','off');
set(gca,'YMinorTick','off');
set(gca,'xtick',xpixels);
set(gca,'ytick',ypixels);
set(gca,'FontSize',10);
set(gca,'yticklabel',qz);
set(gca,'xticklabel',abs(qr));
set(gca,'TickDir','out');
h1=xlabel('$\mathrm{q_r(\AA^{-1})}$','FontSize',14);
h2=ylabel('$\mathrm{q_z(\AA^{-1})}$','FontSize',14);
set(h1,'Interpreter','LaTex');
set(h2,'Interpreter','LaTex');
%ylabel(' q_z (�^{-1})','FontSize',12);
