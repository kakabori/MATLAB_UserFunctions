%  function result=un_wrap(imag,option)
%
%  Converts an X-ray image, imag, from cartesian to polar coordinates.
%  The beam is assumed to be centred on global variables X_cen, Y_cen
%  Returns a map of the values in result
%
%     result.values = N_r*N_theta array of values of image.
%     result.values(l,m) = average value in the region,
%           result.q_values(l)      <= q        <= result.q_values(l+1)
%            result.theta_values(m)  <= theta    <= result.theta_values(m+1)
%     result.value_mask == 1/0 where result.values is defined/un-defined.
%     result.beam_centre = [X_cen, Y_cen]
%  
%  If global variables Spec_to_Phos and X_Lambda are defined then calculation 
%  is done in Reciprocal Angstroms.  Otherwise pixels are used.
%
%  option is a structure where the user can specify various parameters if they choose
%
%       option.radial_bin_minimum
%               -> Mimimum value for q_values. (recip Angstroms).
%               -> eg. option.radial_bin_minimum = 0.05 (reciprocal Angstroms).
%       option.radial_bin_maximum
%               -> Maximum value for q_values. (reciprocal Angstroms).
%       option.radial_bin_number
%               -> Number of radial bins.
%               -> Default is width of image in pixels.
%       option.radial_bin_spacing_mode
%               -> 'linear' or 'squared'
%               -> in 'squared' mode the bin spacing is linear in q^2.
%               -> 'squared' mode is good for peak assigment.
%       option.theta_bin_minimum
%               -> Minimum value of theta
%               -> Must be >= -pi and <= pi.
%       option.theta_bin_maximum
%               -> Maximum value of theta
%               -> Must be greater than theta_bin_minimum and <= pi
%       option.theta_bin_number
%               -> Number of bins in theta
%               -> Default is number of pixels around image.

function  result=un_wrap(imag, option);

    global X_cen Y_cen; global X_Lambda Spec_to_Phos;
    global MaskI;
    
    %  Determine the position of each pixel relative to the beam centre, X_cen, Y_cen. 
    %  For pixel j,k,  x_val(j) <= x <= x_val(j+1);  y_val(k) <= y <= y_val(k+1);
    if ((length(X_cen)<1)|(length(Y_cen)<1))
       X_cen = size(imag,1)*0.5;
       Y_cen = size(imag,2)*0.5;
       fprintf(1,'\nX_cen and Y_cen not initialized.\n');
       fprintf(1,'Integrating about image centre');
    end
    x_val = [0:size(imag,1)]-X_cen;
    y_val = [0:size(imag,2)]-Y_cen;
    
    % If possible, convert pixels to  'q' in reciprocal angstroms.  
    % Otherwise, complain and return q in pixels.
    if ((length(X_Lambda)<1)|(length(Spec_to_Phos)<1))
        fprintf(1,'\n\n X_Lambda and Spec_to_Phos not initialized.\n');
        fprintf(1,'Using pixels rather than reciprocal Angstrom.\n');
    else
        x_val=pixel_to_q(x_val,Spec_to_Phos,X_Lambda);
        y_val=pixel_to_q(y_val,Spec_to_Phos,X_Lambda);
    end

    % If possible use the integration mask.
    if (size(MaskI,1)~=size(imag,1)) | (size(MaskI,2)~=size(imag,2)) 
        fprintf(1,'\n No valid integration mask defined. Including all pixels,\n');
        input_mask=uint8(ones(size(imag)));
    else
        input_mask=MaskI;
    end

    % Use user options to determine integration range
    if (nargin<2) % First fudge up an option structure if not passed by the user.
            option.radial_bin_spacing_mode='linear';
    end
    
    % Set the radial values - r_val
    if isfield(option, 'radial_bin_minimum')&(option.radial_bin_minimum>=0.0)
          r_min = option.radial_bin_minimum;
    else
          r_min = sqrt(min( x_val.*x_val) + min( y_val .* y_val));
    end
    if isfield(option, 'radial_bin_maximum')&(option.radial_bin_maximum>r_min)
         r_max = option.radial_bin_maximum;
    else
         r_max = sqrt(max(x_val .* x_val) + max(y_val .* y_val));   
    end
    if isfield(option,'radial_bin_number')&(option.radial_bin_number>=1)
        N_r = option.radial_bin_number ;
    else
        N_r = ceil(length(imag));
    end
    if strncmp(option.radial_bin_spacing_mode,'squared',1)
        r_val = [0:N_r]/N_r*(r_max*r_max - r_min*r_min) + r_min*r_min ;
        r_val = sqrt(r_val);
    else
        r_val = [0:N_r]/N_r*(r_max-r_min) + r_min;
    end
    
    % Set the theta values.
   if isfield(option,'theta_bin_minimum')&(option.theta_bin_minimum>= -1.0*pi)&(option.theta_bin_maximum<= pi)
        t_min = option.theta_bin_minimum;
   else
        t_min = -1.0* pi;     
   end
   if isfield(option,'theta_bin_maximum')&(option.theta_bin_maximum>option.theta_bin_minimum)&(option.theta_bin_maximum<= pi)
        t_max = option.theta_bin_maximum;
   else
        t_max = pi;
   end
   if isfield(option,'theta_bin_number')&(option.theta_bin_number>=1)
       N_t = option.theta_bin_number;
   else
       N_t = ceil(length(imag)/2);
   end
   theta_val = (([0:N_t])/N_t)*(t_max-t_min) + t_min; 
        
   % Call cartesian_to_polar    
    f=double(imag);
    [g, output_mask] = cartesian_to_polar(f, x_val, y_val, input_mask, r_val, theta_val);
 
    % Load the results into a structure
       result.values = g;
       result.value_mask = output_mask;
       result.q_values = r_val;
       result.theta_values = theta_val;
       result.beam_centre = [X_cen, Y_cen];
   