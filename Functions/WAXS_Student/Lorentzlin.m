%result = Lorentzlin(param, data)
% parameters -> Coefficients of the Lorentzian + linear background.
%           param(1) = Peak Height of Lorentzian.
%           param(2) = Peak Centre of Lorentzian.
%           param(3) = Peak Width of Lorentzian.
%           param(4) = Constant background.
%           param(5) = Linear slope of background.
%
%   data --> q values on which lorenztian should be evaluated
%   result --> Intensity of lorentzian for each q.


function result = Lorentzlin(param, data)

    result = param(1) ./ (1 + (data-param(2)).*(data-param(2))/(param(3)*param(3))) + param(4) + param(5)*data;
    