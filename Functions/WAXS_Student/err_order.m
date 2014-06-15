%5/4/06 TTM
%5/2/07-Oops- This is wrong-need change
%Needed to square the dS/dm also or just errS=errm*ds/dM:
% function result=err_order(m,errm)
% N=10000;
% B=[1:N];
% B=(B-0.5)/N*pi;  %Checked 5/2/07-not matter if use pi or pi/2
%                    %-cuz dividing by in denominator. 
% w=exp(m*cos(B).*cos(B)).*sin(B);
% p=0.5*(3*cos(B).*cos(B)-1);
% c=cos(B).*cos(B);
% result=sqrt(errm*errm*(sum(w)*sum(c.*w.*p)-sum(w.*p)*sum(c.*w))/(sum(w)*sum(w)));

%Redid 5/2/07-corrected-errors will be less because not taking sqaure root
%of dS/dm (which is usually less than 1)

function result=err_order(m,errm)
N=10000;
B=[1:N];
B=(B-0.5)/N*pi;  %Checked 5/2/07-not matter if use pi or pi/2
                   %-cuz dividing by in denominator. 
w=exp(m*cos(B).*cos(B)).*sin(B);
p=0.5*(3*cos(B).*cos(B)-1);
c=cos(B).*cos(B);
num=sum(w)*sum(c.*w.*p)-sum(w.*p)*sum(c.*w);
den=sum(w)*sum(w);
result=errm*num/den;
