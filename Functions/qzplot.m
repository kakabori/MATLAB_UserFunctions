%function qzplot(imag,columns)
%Plots mean intensity v. pixel for columns specified as [c1,c2].

function [temp]=qzplot(imag,columns)

temp=mean( imag(:,[columns(1):columns(2)]),2);

plot(temp);