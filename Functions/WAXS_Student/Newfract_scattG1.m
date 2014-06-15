%function [Fscatt_030,Fscatt_6090]=Newfract_scattG1(result)
%modified from fract_scattG1 which was written:
%TTM 5/22/06; modified from fract_scattX1.m

%01/02/07 changed so uses NewMaierG (which avoids using the "mfun" Matlab function.

function [Fscatt_030,Fscatt_6090]=Newfract_scattG1(result)
N=10000;
Btot=[1:N];
Btot=(Btot-0.5)/N*90;
B30=[1:N/3];
B30=(B30-0.5)/N*90;
B60=[2*N/3:N];
B60=(B60-0.5)/N*90;

tot=sum(NewMaierG(result,Btot) - result(1));
Fscatt_030=sum(NewMaierG(result,B30) - result(1))/tot;
Fscatt_6090=sum(NewMaierG(result,B60) - result(1))/tot;
