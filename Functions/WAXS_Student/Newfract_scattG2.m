%function [Fscatt_030,Fscatt_6090]=Newfract_scattG2(result)
% called by NewFitPhi_MSG2
% calls NewMaierG2 (which has been modified to be compatible with the student 
% version by no longer calling the Matlab function mfun. 

% modified from 
% function [Fscatt_030,Fscatt_6090]=fract_scattG2(result)
%TTM 5/22/06; modified from fract_scattX2

% 1/2/08 Newfract_scattG2 created by TTM

function [Fscatt_030,Fscatt_6090]=Newfract_scattG2(result)
N=10000;
Btot=[1:N];
Btot=(Btot-0.5)/N*90;
B30=[1:N/3];
B30=(B30-0.5)/N*90;
B60=[2*N/3:N];
B60=(B60-0.5)/N*90;

tot=sum(NewMaierG2(result,Btot) - result(1));
Fscatt_030=sum(NewMaierG2(result,B30) - result(1))/tot;
Fscatt_6090=sum(NewMaierG2(result,B60) - result(1))/tot;