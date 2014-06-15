% function [Fchains_030,Fchains_6090]=Newfract_chains2(A1,m1,A2,m2)
%This function is called by NewFitPhi_MSG2
%uses NewMSnorm, which uses the "dawson" function (downloaded from the web) instead of call to
%'dawson' in mfun (which does not work with the student edition)

% based on [Fchains_030,Fchains_6090]=fract_chains2(A1,m1,A2,m2)
%TTM 5/8/06
%modified 9/25/06 to take account for Maier-Saupe normalization factor

%very old function (not account for normalization:
%function [Fchains_030,Fchains_6090]=fract_chains2(A1,m1,A2,m2)
%N=10000;
%Btot=[1:N];
%Btot=(Btot-0.5)/N*pi/2;
%B30=[1:N/3];
%B30=(B30-0.5)/N*pi/2;
%B60=[2*N/3:N];
%B60=(B60-0.5)/N*pi/2;
%tot=A1*sum(exp(m1*cos(Btot).*cos(Btot)).*sin(Btot)) + A2*sum(exp(m2*cos(Btot).*cos(Btot)).*sin(Btot));
%Fchains_030=(A1*sum(exp(m1*cos(B30).*cos(B30)).*sin(B30)) + A2*sum(exp(m2*cos(B30).*cos(B30)).*sin(B30)))/tot;
%Fchains_6090=(A1*sum(exp(m1*cos(B60).*cos(B60)).*sin(B60)) + A2*sum(exp(m2*cos(B60).*cos(B60)).*sin(B60)))/tot;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

%TTM 1/2/08 Newfract_chains2 created

function [Fchains_030,Fchains_6090]=Newfract_chains2(A1,m1,A2,m2)
N=10000;
Btot=[1:N];
Btot=(Btot-0.5)/N*pi/2;
B30=[1:N/3];
B30=(B30-0.5)/N*pi/2;
B60=[2*N/3:N];
B60=(B60-0.5)/N*pi/2;

tot=A1*NewMSnorm(m1)*sum(exp(m1*cos(Btot).*cos(Btot)).*sin(Btot)) + A2*NewMSnorm(m2)*sum(exp(m2*cos(Btot).*cos(Btot)).*sin(Btot));
Fchains_030=(A1*NewMSnorm(m1)*sum(exp(m1*cos(B30).*cos(B30)).*sin(B30)) + A2*NewMSnorm(m2)*sum(exp(m2*cos(B30).*cos(B30)).*sin(B30)))/tot;
Fchains_6090=(A1*NewMSnorm(m1)*sum(exp(m1*cos(B60).*cos(B60)).*sin(B60)) + A2*NewMSnorm(m2)*sum(exp(m2*cos(B60).*cos(B60)).*sin(B60)))/tot;