%function [data_out,fit_out,residual] = NewFitPhi_MSG(data, range, param,offset,name_data)
%Same as FitPhi_MSG (except the "New" version calls NewMaierG, which uses
%the "dawson" function (downloaded from the web)
%instead of "mfun", which is not available on the student version or on the
%Nagle linux computers (linx2 or the Math/Phys computer cluster)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modified from:
% function [result, std_dev, S] = FitPhi_MSG(data, range, param)
%
% data --> I versus phi from integrate_annulus
% range -> [phi_min, phi_max] -> eg. [0.8 1.8] -> range to fit I versus phi in.
% parameters -> Coefficients of the Maier-Saupe fit.
%           param(1) = Iback=constant background.
%           param(2) = A=scaling factor
%           param(3) = m=Maier-Saupe parameter.
%
%  Output - Plot of fit + result -> parameters + std_dev = root mean square
%  error of fit.  S=molecular order parameter=1/2(3cosB*cosB-1)
%  TTM 5/22/06; modified from FitPhi_MSX.m
%  chi_square added 7/6/06
%  df,SSE,R2,adjR2,RMSE added 7/25/06

%  Modified 8/25/06 to output the data (only in the fitting range) and fit
%  (from phi=0 to 90); Used frprintf command to output fitting info to screen
%  Used to look like this:
%  function [df,SSE,R2,adjR2,RMSE,Iback,A,m,std_dev,ci,err,S,errS,Fchains_030,Fchains_6090,Fscatt_030,Fscatt_6090] = FitPhi_MSG(data, range, param,offset,name_data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TTM 12/21/07 (finished 1/02/08) NewFitPhi_MSG created
% Also involves changing the following functions to be compatible:
% NewMaierG
% Newfract_scattG1


function [data_out,fit_out,residual] = NewFitPhi_MSG(data, range, param,offset,name_data)

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
[result,resnorm,resid,exitflag,output,lambda,j] = lsqcurvefit( @NewMaierG, param, phi, I,[0,0,0],[inf,inf,inf],optim_param);

% Define fitting parameters and derived parameters
Ifit = NewMaierG(result, phi);
df=length(I)-3;
SSE=sum(resid.*resid);
%SSEalt=sum( (Ifit-I).*(Ifit-I) ); gives same value as SSE-I checked
%SSEalt=norm(resid).^2;  gives same value as SSE
SST=sum((I-mean(I)).*(I-mean(I)));
R2=1-SSE/SST;
adjR2=1-(SSE/SST*(length(I)-1)/df);
RMSE=sqrt(SSE/df);

std_dev = sqrt(mean( (Ifit-I).*(Ifit-I) ));
%[ypred,delta]=nlpredci(@MaierG,phi,result,resid,j)
%resid
%chi_square=1/(std_dev*std_dev)*sum( (Ifit-I).*(Ifit-I) )/(std_dev*std_dev);
%chi_square=sum(((Ifit-I).*(Ifit-I))./(delta.*delta));
ci=nlparci(result,resid,j);
Iback=result(1);
A=result(2);
m=result(3);
err=[0.5*(ci(1,2)-ci(1,1)),0.5*(ci(2,2)-ci(2,1)),0.5*(ci(3,2)-ci(3,1))];
errIback=err(1); errA=err(2); errm=err(3); 
S=order(result(3));
errS=err_order(result(3),err(3));
[Fchains_030,Fchains_6090]=fract_chains1(m);
%[Fscatt_030,Fscatt_6090]=fract_scattG1(result);

%Print out fitting parameters
fprintf('\ndf=%g  SSE=%g  RMSE=%g  adjR2=%g  R2=%g\n\n', df, SSE, RMSE, adjR2, R2);
fprintf('Iback=%g  A=%g  m=%g\n\n',Iback,A,m);
fprintf('errIback=%g  errA=%g  errm=%g\n\n',errIback,errA,errm);
fprintf('S=%g  errS=%g\n\n',S,errS);
fprintf('Fchains_030=%g  Fchains_6090=%g\n\n', Fchains_030, Fchains_6090);
%fprintf('Fscatt_030=%g  Fscatt_6090=%g\n\n', Fscatt_030, Fscatt_6090);

%Now plot the data
plot(phi, I+offset,'k.'); 
hold on;
phiplot=[0:1:89];   %for I v phi plots; allows plots of fits to be different than range fitted.
Iplot=(NewMaierG(result,phiplot));
phiplot=phiplot';
Iplot=Iplot';
plot(phiplot, Iplot+offset,'r');

data_out=[phi, (I-Iback)/A];   %was normalized to A/4pi-changed to just A 9/19/06
fit_out=[phiplot,(Iplot-Iback)/A];
residual=[phi,resid/A];

names={name_data,'FitPhi-MSG'};
legend(names,'Fontsize',10);
xlabel('{\it\phi} (deg)');
ylabel('Intensity (arb.)');
    
    