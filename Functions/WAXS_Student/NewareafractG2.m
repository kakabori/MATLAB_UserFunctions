%function [AreaF1,AreaF2]=NewareafractG2(result)
% Calculates total fraction of scattering for each phase (This is different
% from phase fractions P1 and P2)

%Same as  areafractG2 (except the "New" version calls NewMaierG2 and NewMaierG, which uses
%the "dawson" function (downloaded from the web)
%instead of "mfun", which is not available on the student version or on the
%Nagle linux computers (linx2 or the Math/Phys computer cluster)

%TTM 5/22/06 areafractG2 written; modified from areafractx2.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TTM 1/2/08 NewareafractG2 created

function [AreaF1,AreaF2]=NewareafractG2(result)
N=10000;
Btot=[1:N];
Btot=(Btot-0.5)/N*90;

tot=sum(NewMaierG2(result,Btot) - result(1));
AreaF1=sum(NewMaierG([result(1),result(2),result(3)],Btot) - result(1))/tot;
AreaF2=sum(NewMaierG([result(1),result(4),result(5)],Btot) - result(1))/tot;
