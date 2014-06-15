%function [data_out,fit_out,residual] = NewFitPhi_MSG2(data, range, param,offset,name_data)
%%Same as FitPhi_MSG2 (except the "New" version calls NewMaierG2, which uses
%the "dawson" function (downloaded from the web)
%instead of "mfun", which is not available on the student version or on the
%Nagle linux computers (linx2 or the Math/Phys computer cluster)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%modified from FitPhi_MSG2
% data --> I versus phi from integrate_annulus
% range -> [phi_min, phi_max] -> eg. [0.8 1.8] -> range to fit I versus phi in.
% parameters -> Coefficients of the Maier-Saupe fit.
%           param(1) = Iback=constant background.
%           param(2) = A1=scaling factor
%           param(3) = m1=Maier-Saupe parameter.
%           param(4) = A2
%           param(5) = m2
%
%  Output - Plot of fit + result -> parameters + std_dev = root mean square
%  error of fit.  S=molecular order parameter=1/2(3cosB*cosB-1)
%  TTM 5/22/06 (modified from FitPhi_MSX2.m)
%  df,SSE,R2,adjR2,RMSE added 7/25/06
%  errP1 and errP2 added 8/22/06; revised 8/23/06
%  function

%  Modified 8/25/06 to output the data (only in the fitting range) and fit
%  (from phi=0 to 90); Used frprintf command to output fitting info to screen
%  Used to look like this:
%  function [df,SSE,R2,adjR2,RMSE,Iback,A1,m1,A2,m2,std_dev,ci,err,S1,S2,errS1,errS2,P1,P2,errP1,errP2,AreaF1,AreaF2,Fchains_030,Fchains_6090,Fscatt_030,Fscatt_6090] = FitPhi_MSG2(data, range, param,offset,name_data)

% 12/21/07 TTM (finished 1/2/08) NewFitPhi_MSG2 created
% Also involves changing the following functions to be compatible:
% NewMaierG2
% NewareafractG2
% Newfract_chains2
% NewMSnorm (called by Newfract_chains2)
% Newfract_scattG2


function [data_out,fit_out,residual] = NewFitPhi_MSG2(data, range, param,offset,name_data)

% Step One - Get just the data in the range that we want.
Nmax = size(data,1);
Nstart = 1;
while( Nstart<Nmax)&(data(Nstart,1)<range(1))
    Nstart=Nstart+1;
end
Nfinish=Nstart+1;
while(Nfinish<Nmax)&(data(Nfinish,1)<range(2))
    Nfinish=Nfinish+1;
end
phi = data([Nstart:Nfinish],1);  %If not want negative copy of data
I = data([Nstart:Nfinish],2);
%if want negative copy
%phi = [-data([Nstart:Nfinish],1);data([Nstart:Nfinish],1)];  
%I = [data([Nstart:Nfinish],2);data([Nstart:Nfinish],2)];

%set options
optim_param=optimset('MaxFunEvals',100000,'MaxIter',100000);
% Fit the data.
[result,resnorm,resid,exitflag,output,lambda,j] = lsqcurvefit( @NewMaierG2, param, phi, I,[0,0,0,0,0],[inf,inf,inf,inf,inf],optim_param);

%Now plot the data
plot(phi, I+offset,'k.'); 
hold on;
phiplot=[0:1:89];   %for I v phi plots; allows plots of fits to be different than range fitted.
Iplot=NewMaierG2(result,phiplot);

phiplot=phiplot';    %added 11/13/06
Iplot=Iplot';

Ifit = NewMaierG2(result, phi);   %not need to be transposed because phi is already a column vector
plot(phiplot, Iplot+offset,'m');

names={name_data,'FitPhi-MSG2'};
legend(names,'Fontsize',10);
xlabel('{\it\phi} (deg)');
ylabel('Intensity (arb.)');

%Now define fitting parameters
df=length(I)-5;
SSE=sum(resid.*resid);
SST=sum((I-mean(I)).*(I-mean(I)));
R2=1-SSE/SST;
adjR2=1-(SSE/SST*(length(I)-1)/df);
RMSE=sqrt(SSE/df);

std_dev = sqrt(mean( (Ifit-I).*(Ifit-I) ));
ci=nlparci(result,resid,j);
Iback=result(1);
A1=result(2);
m1=result(3);
A2=result(4);
m2=result(5);
err=[0.5*(ci(1,2)-ci(1,1)),0.5*(ci(2,2)-ci(2,1)),0.5*(ci(3,2)-ci(3,1)),0.5*(ci(4,2)-ci(4,1)),0.5*(ci(5,2)-ci(5,1))];
errIback=err(1); errA1=err(2); errm1=err(3); errA2=err(4); errm2=err(5);
S1=order(result(3));
S2=order(result(5));
errS1=err_order(result(3),err(3));
errS2=err_order(result(5),err(5));
P1=A1/(A1+A2);
P2=A2/(A1+A2);

%Added 6/12/07-New error calculations for phase fractions
dP1_dA1=(A1+A2)^(-1)-A1*(A1+A2)^(-2);
dP1_dA2=-A1*(A1+A2)^(-2);
dP2_dA2=(A1+A2)^(-1)-A2*(A1+A2)^(-2);
dP2_dA1=-A2*(A1+A2)^(-2);
errP1=sqrt(errA1^2*dP1_dA1^2 + errA2^2*dP1_dA2^2);
errP2=sqrt(errA1^2*dP2_dA1^2 + errA2^2*dP2_dA2^2);

%errA1A2=sqrt(errA1^2 + errA2^2);
%errP1=sqrt(A1^2*errA1A2^2 + (A1+A2)^2*errA1^2);  These are wrong
%errP2=sqrt(A2^2*errA1A2^2 + (A1+A2)^2*errA2^2);

% errP1=sqrt(P1^2*((errA1/A1)^2 + (errA1A2/(A1+A2))^2));  %6/12/07 also
% wrong-fixed on excel spreadsheet for thesis-need to fix here also
% errP2=sqrt(P2^2*((errA2/A2)^2 + (errA1A2/(A1+A2))^2));

%[P1,P2]=fract_phase(result(2),result(3),result(4),result(5));  This was
%old way- before normalized Maier-Saupe

[AreaF1,AreaF2]=NewareafractG2(result);
[Fchains_030,Fchains_6090]=Newfract_chains2(A1,m1,A2,m2);
[Fscatt_030,Fscatt_6090]=Newfract_scattG2(result);

data_out=[phi, (I-Iback)/(A1+A2)];   %Put in normalization 9/19/06
fit_out=[phiplot,(Iplot-Iback)/(A1+A2)];
residual=[phi,resid/(A1+A2)];

%Print out fitting parameters
fprintf('\ndf=%g  SSE=%g  RMSE=%g  adjR2=%g  R2=%g\n\n', df, SSE, RMSE, adjR2, R2);
fprintf('Iback=%g  A1=%g  m1=%g  A2=%g  m2=%g\n\n',Iback,A1,m1,A2,m2);
fprintf('errIback=%g  errA1=%g  errm1=%g  errA2=%g  errm2=%g\n\n',errIback,errA1,errm1,errA2,errm2);
fprintf('S1=%g  S2=%g  errS1=%g  errS2=%g\n\n',S1,S2,errS1,errS2);
fprintf('P1=%g  P2=%g  errP1=%g  errP2=%g\n\n',P1,P2,errP1,errP2);
fprintf('AreaF1=%g  AreaF2=%g\n\n', AreaF1, AreaF2);
fprintf('Fchains_030=%g  Fchains_6090=%g\n\n', Fchains_030, Fchains_6090);
fprintf('Fscatt_030=%g  Fscatt_6090=%g\n\n', Fscatt_030, Fscatt_6090);


    
    