%8/17/06 Thalia Mills 
%revised to perspective of difference in angles 8/23/06

function [x,qres]=GeomBroad(q,fp,lam,sd)

%perspective of fixed angle
x=sd * tan( 2* asin( lam*q/(4*pi) ) );
x1=x;
x2=(sd-0.5*fp)/(sd+0.5*fp)*x;
qres=(4*pi/lam)*(sin(0.5*atan(x1/sd))-sin(0.5*atan(x2/sd)));

% D1=sd+0.5*fp;
% D2=sd-0.5*fp;
% x=sd * tan( 2* asin( lam*q/(4*pi) ) );
% qres=-(4*pi/lam)*(sin(0.5*atan(x/D1))-sin(0.5*atan(x/D2)));