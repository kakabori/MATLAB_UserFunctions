%function result=NewMSnorm(m)
%This function is used by Newfract_chains2.m, which is called by
%NewFitPhi_MSG2.m
% This was the old function, which used a call to dawson's integral in
% the built-in Matlab function "mfun." mfun does not work on the student
% edition (as well as the Nagle linux and CMU math/phys cluster linux machines).
% Instead uses the function "dawson" downloaded from the web, which does work with the
% student edition.
%modified from function result=MSnorm(m)
%result=1/(4*pi)*exp(-m)*sqrt(m)/(mfun('dawson', sqrt(m)));
%9/25/06

%This function just numerically calculates 1/Z, the Maier-Saupe
%normalization constant with input parameter m.

% TTM 1/2/08 NewMSnorm created 

function result=NewMSnorm(m)
result=1/(4*pi)*exp(-m)*sqrt(m)/(dawson(sqrt(m)));