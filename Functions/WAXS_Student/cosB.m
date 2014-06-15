%function result=cosB(m)
%calculates the average value of cosine(B) for use in the molecular area
%formula.
%if use 0 to pi integration range- need calculate average of abs. value of cosB
%TTM 3/20/07 modified from order(m)

function result=cosB(m)
N=10000;
B=[1:N];
% B=(B-0.5)/N*pi;  %sets integration range=0 to pi
B=(B-0.5)/N*pi/2; %sets integration range=0 to pi/2
w=exp(m*cos(B).*cos(B)).*sin(B);
% p=abs(cos(B));   %to use with range=0 to pi
p=cos(B);  %to use with int. range=0 to pi/2
result=sum(w.*p)/sum(w);

