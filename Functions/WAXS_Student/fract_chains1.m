%TTM 5/5/06 and 5/8/06

function [Fchains_030,Fchains_6090]=fract_chains1(m)
N=10000;
Btot=[1:N];
Btot=(Btot-0.5)/N*pi/2;
B30=[1:N/3];
B30=(B30-0.5)/N*pi/2;
B60=[2*N/3:N];
B60=(B60-0.5)/N*pi/2;

tot=sum(exp(m*cos(Btot).*cos(Btot)).*sin(Btot));
Fchains_030=sum(exp(m*cos(B30).*cos(B30)).*sin(B30))/tot;
Fchains_6090=sum(exp(m*cos(B60).*cos(B60)).*sin(B60))/tot;

