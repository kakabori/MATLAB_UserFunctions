%function result = integrate_annulus_basic(imag, q_range, phi_range, N_phi)
%
%   Function to perform annular integral on x-ray scattering image - imag.
%   Inputs -  imag -> N*M x-ray scattering image.
%             q_range -> Integrate annulus for q_range(1) < q < q_range(2)
%                        Units are reciprocal Angstroms.
%                        Default values are  0.8 A^-1 to 1.8 A^-1.
%             phi_range -> Calculate for phi_range(1) < phi < phi_range(2)
%                          Angles are in degrees and measured
%                          counter-clockwise from (+)horizontal (right)
%                          Defaults are 0 degrees to 90 degrees.
%             N_phi -> Divide angular (phi) range into N_phi bins.
%                      Default is 90 bins.
%
%   Output - result ->  result(j,1) = angle, phi, at centre of bin j.
%                       result(j,2) = avg intensity per pixel for bin j.
%
%   Global variables - X_cen, Y_cen , X_Lambda, Spec_to_Phos, MaskI
%
% Algorithm ->
%       Examine each pixel in turn – imag(j,k)
%       Calculate q and phi for pixel.
%   Confirm pixel has not been masked out -> MaskI(j,k)==1
%   Determine if pixel lies in radial limits of annulus
%  		q_range(1) < q < q_range(2)	
%	Determine if pixel lies in angular range.
%		phi_range(1) < phi < phi_range(2)
%	Assuming all three of the above conditions are satisfied, 
%	the pixel lies in one of the (N_phi) angular bins.
%   A pixel at, phi, lines in bin
%   	j = ceil((phi-Phi_range(1))/Phi_per_Bin)	
%   where
%		Phi_per_Bin = (Phi_range(2)-Phi_range(1))/N_phi 
%	The intensity in bin j is described by
%		I(j) = Integrated intensity for pixels within the j-th bin.
%		Npix(j) = Number of pixels in the j-th bin.
%	The intensity of the pixel is added to I(j) and the number of pixels in bin j, Npix(j) is augmented by 1.
%
%	Once all pixels have been considered, one can calculate
%		Intensity per pixel for each bin = I(j)/Npix(j)
%		Value of phi at centre of bin = = phi_range(1) + (j-0.5)*Phi_per_Bin
%
%   GEST 18 July, 2008. 

function result = integrate_annulus_basic(imag, q_range, phi_range, N_phi)

    % PARSE INPUTS

    % Get Global variables

    global X_cen Y_cen; global X_Lambda Spec_to_Phos;

    global MaskI;



    % Get image size

    [Nrow, Ncol] = size(imag);



    % Set q_range 

    if (nargin<2)

        q_range = [0.8 1.8]; % Default q-range is 0.8 A^-1 < q < 1.8 A^-1.

    end

    

    % Set phi_range

    if (nargin<3)

        phi_range(1) = 0;  % Start at 0 degrees (horizontal axis going right)

        phi_range(2) = 90; % Finish at 90 degrees (vertical axis going up).

    end

    

    % Set number of angular bins.

    if (nargin<4)

        N_phi = 90; % Default is 90 angular bins.

    end

    

   %NOW DO ACTUAL CALCULATION!

   %Initialize variables for integral

   I = zeros(N_phi, 1); % Intensity per pixel as function of angle.

   Npix = zeros(N_phi,1); % Number of valid pixels as function of angle.

   

   % Calculate angular size per bin.

   phi_perbin = (phi_range(2)-phi_range(1))/N_phi;

            

   % Calculate radial range in pixels.

   r_min = Spec_to_Phos * tan( 2 * asin(q_range(1) * X_Lambda / (4*pi) ) );

   r_max = Spec_to_Phos * tan( 2 * asin(q_range(2) * X_Lambda / (4*pi) ) );

    

    % Go through image pixel by pixel 

    % Work out which angular bin pixel lies in (if any).

    % Put intensity into the appropriate angular bin.

    for j=1:Nrow

        for k=1:Ncol

            

            if (MaskI(j,k)==1) % Pixel has not been masked out

            

                %Compute distance of pixel from beam centre in pixels.

                rd = j-X_cen-0.5; cd = k-0.5-Y_cen;

                radius = sqrt(rd*rd + cd*cd); 

            

                if (radius>r_min)&(radius<r_max) % Pixel is within radial range



                    % Compute angle of pixel (degrees)

                    phi = atan2(-rd, cd)*180/pi;

                    bin = ceil((phi-phi_range(1))/phi_perbin); % Determine angular bin

               

                    if (bin>0)&(bin<=N_phi) % Pixel is in one of the bins

                        I(bin) = I(bin) + imag(j,k); % Add intensity to bin

                        Npix(bin) = Npix(bin)+1;     % And count number of pixels in bin

                    end             

                end

            end

        end

    end

    

    % Calculate angle at centre of each angular bin

    phi_values = ([1:N_phi]'-0.5) * phi_perbin + phi_range(1);

 

    % Calculate Intensity per pixel for each bin.

    I = I./Npix;

    

    % Return result.

    result = [phi_values, I];
