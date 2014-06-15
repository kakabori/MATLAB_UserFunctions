%function result=Bsquare(m)
%Calculates the average value of B^2 (to compare with undulation
%fluctuations)

%if use 0 to pi integration range- need calculate average of abs. value of cosB
%TTM 4/8/07 modified from cosB(m)

function result=Bsquare(m)
N=10000;
B=[1:N];
% B=(B-0.5)/N*pi;  %sets integration range=0 to pi
B=(B-0.5)/N*pi/2; %sets integration range=0 to pi/2
w=exp(m*cos(B).*cos(B)).*sin(B);
p=B.*B;  %to use with int. range=0 to pi/2
result=sum(w.*p)/sum(w);

