%TTM 5/4/06

function result=order(m)
N=10000;
B=[1:N];
B=(B-0.5)/N*pi;
w=exp(m*cos(B).*cos(B)).*sin(B);
p=0.5*(3*cos(B).*cos(B)-1);
result=sum(w.*p)/sum(w);