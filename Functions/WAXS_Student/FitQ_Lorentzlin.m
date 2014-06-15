%function [data_out, std_dev, integ] = FitQ_Lorentzlin(data, range, param)
%
% data --> I versus q from integrater or integrate_sector
% range -> [q_min, q_max] -> eg. [0.8 1.8] -> range to fit I versus q in.
% parameters -> Coefficients of the Lorentzian + linear background.
%           param(1) = Peak Height of Lorentzian.
%           param(2) = Peak Centre of Lorentzian.
%           param(3) = Peak Width of Lorentzian.
%           param(4) = Constant background.
%           param(5) = Linear slope of background.
%       eg. [200 1.4 0.2 50 10]
%           Lorentzian of heigh 200 centred at q=1.4 with HWHM of 0.2 
%           sitting on a linear background that is 50 at q=0 and 70 at q=2.
%
%  Output - Plot of fit (an only linear portion) + result -> parameters + std_dev = root mean square
%  error of fit.  integ=integral of Lorentzian in q range provided.
%Modified 2/15/06 to output the data, fit, and linear background as variables.
%Prints the fitting parameters, integ, and standard dev. to the MATLAB
%screen

function [data_out, fit_out, lin_out] = FitQ_Lorentzlin(data, range, param)

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
q = data([Nstart:Nfinish],1);  
I = data([Nstart:Nfinish],2);

%set options
optim_param=optimset('MaxFunEvals',50000,'MaxIter',10000);
% Fit the data.
result = lsqcurvefit( @Lorentzlin, param, q, I,[],[],optim_param);

%Now plot the data
plot(q, I,'b'); 
hold on;
Ifit = Lorentzlin(result, q);
std_dev = sqrt(mean( (Ifit-I).*(Ifit-I) ));
integ=result(1)*result(3)*(atan((range(2)-result(2))/result(3))-atan((range(1)-result(2))/result(3)));
plot(q, Ifit,'r');
Ilin=result(4)+result(5).*q;
plot(q,Ilin,'k');    %Plots linear part of fit
names={'Expt','Fit','Linear background'};
legend(names,'Fontsize',7);
xlabel('Q - (A^{-1})');
ylabel('I (arb. units)');

%Print out fitting parameters
fprintf('\nheight=%g  center=%g  width=%g  y-int.(back)=%g  slope(back)=%g\n\n', result(1), result(2), result(3), result(4), result(5));
fprintf('std_dev=%g\n\n',std_dev);
fprintf('integ=%g\n\n',integ);

%Assign the fitting outputs
data_out=[q I];
fit_out=[q Ifit];
lin_out=[q Ilin];


    
    