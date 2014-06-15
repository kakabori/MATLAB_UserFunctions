%function qrplot(imag,rows)
%Plots mean intensity v. pixel for rows specified as [r1,r2].

function [temp]=qrplot(imag,rows)

temp=mean( imag([rows(1):rows(2)],:),1);

plot(temp);