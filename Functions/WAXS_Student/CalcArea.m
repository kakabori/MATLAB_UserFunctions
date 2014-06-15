%function CalcArea(m,d)
%Calculates the area per headgroup using two different approximations for
%sec(Beta).  Uses the Maier_saupe fitting parameter m and the chain-chain 
%correlation distance d (=2pi/qcc) as input.
%
%TTM 7/16/07
%8/15/07 added sec3
function CalcArea(m,d)

sec1=1/cosB(m);
sec2=3-3*cosB(m)+cos2B(m);
sec3=cos2B(m)*(cosB(m))^(-3);
Area1=4/sqrt(3)*d*d*sec1;
Area2=4/sqrt(3)*d*d*sec2;
Area3=4/sqrt(3)*d*d*sec3;
fprintf('Area1=%g  Area2=%g Area3=%g  sec1=%g sec2=%g sec3=%g\n\n',Area1,Area2,Area3,sec1,sec2,sec3);