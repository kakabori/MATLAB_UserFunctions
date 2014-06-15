% function peak_data = peak_phi( Data, q_range, mode);
%
%  A peak-finding function for X-ray powder data.
%  Data is a 2-column vector of  [q, I] form.
%  q_range is a 2-column vector of [q_low, q_high].
%  For each tuple of q_low(j),q_high(j), Find_Peaks looks through
%  Data in the range q_low to q_low in search of a relative maximum.
%  should it find one within the range it processes it as follows.
%   
%    Define the following elements of the peak_data class.
%           q_max = q-value with the maximum intensity
%           I_max = intensity at q_max
%           I_min_pos = For q > q_max the intensity drops to a local minimum value.
%           q_min_pos = q value corresponding to I_min_pos.
%           I_man_neg = For q < q_max the intensity drops to a local minimum value.
%           q_min_neg = q value corresponding to I_min_neg.
%           Full_Area = Integrated peak area from q_min_neg to q_min_pos.
%           Cap_Area = Integrated peak area within the FWHM of peak.
%           FWHM = maximum of FWHM on left and right sides.
%           description = a string describing the peak.
%
%   If there is no maximum in the range given then,
%          I_max= maximum intensity
%          Full_Area=Cap_Area=0
%          Everything else = NaN.
%
%  mode is an optional third parameter.
%  if mode = 'rough' then just grabs the highest point in the range.
%	Half_width will not be as accurate in this mode either.
%  if mode = 'quad' then does a quadratic fit to the points within 80% of the 
%  maximum.  Similarly, it does a linear fit to interpolate the halfwidth
%  default is 'quad'.

%3/20/2006 GET and TTM

function peak_data = peak_phi( data, phirange)
 
%Pick out data in allowed angle range
nlength=size(data,1);
jmin=1;
while (jmin<nlength)&(data(jmin,1)<phirange(1))
    jmin=jmin+1;
end
jmax=jmin;
while (jmax<nlength)&(data(jmax,1)<phirange(2))
    jmax=jmax+1;
end
x=data([jmin:jmax],1);
y=data([jmin:jmax],2);
nelement=size(x,1);
%Find max
[Imax,rowmax]=max(y);
phimax=x(rowmax);
    
%Set phimin and Imin to last data point in range
phimin=x(nelement);
Imin=y(nelement);

%Calculate Ihalf and find phihalf
Ihalf=0.5*(Imin+Imax);
phihalf=interp1(y([rowmax:nelement]),x([rowmax:nelement]),Ihalf);  
%only takes region where data monotonic 

% Stuff results into class.
peak_data.phimax=phimax; peak_data.Imax=Imax;
peak_data.phimin=phimin; peak_data.Imin=Imin;
peak_data.phihalf=phihalf; peak_data.Ihalf=Ihalf;
end


    
