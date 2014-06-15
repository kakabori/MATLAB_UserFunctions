% TTM 8/14/06 to test normalization
%note need dB=step size because do not have a denominator
%modified so go to pi/2-cuz that wat definition was
%f(B)sinBdB integrated from 0 to pi/2 should equal 1/4pi

%Old version:
%function [norm_nopi,norm_pi]=TestNorm(m)

% N=10000;
% B=[1:N];
% B=(B-0.5)/N*pi;
% w=exp(m*cos(B).*cos(B)).*sin(B);
% norm=exp(-m)*sqrt(m)/(mfun('dawson', sqrt(m)));
% step=pi/N;
% norm_nopi=sum(w.*norm*step);
% norm_pi=sum((2*pi)/(4*pi)*w.*norm*step);

%TTM 5/7/07- new version:

function [integral]=TestNorm(m)
N=10000;
B=[1:N];
B=(B-0.5)/N*pi/2;
w=exp(m*cos(B).*cos(B)).*sin(B);
norm=1/(4*pi)*exp(-m)*sqrt(m)/(mfun('dawson', sqrt(m)));
step=pi/2/N;
integral=sum(w.*norm*step);
