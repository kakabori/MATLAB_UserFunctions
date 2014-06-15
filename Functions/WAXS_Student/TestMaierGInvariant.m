% TTM 9/19/06 to test the invariant for MaierG
% sum (I*cosphi*dphi)=1/8=0.125
%Checked-this works for all m
%note need dB=step size because do not have a denominator

function [invariant]=TestMaierGInvariant(m)

N=10000;
B=[1:N];
B=(B-0.5)/N*90;
step=pi/(2*N);
w=MaierG([0,1,m],B).*cosd(B);
invariant=sum(w*step);


