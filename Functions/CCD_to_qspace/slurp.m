% function result = slurp(varargin)
%       Multipurpose TV6 TIFF Image Loading Function.
%       
%  Function One - Single Image Loading
%       result = slurp(fname,options)
%   
%       Slurp loads the image in "fname" into "result"
%       Options (which are optional) include
%                      s -  signed image (TV6 has processed the TIFF 
%                      c -  image has been intensity and distortion corrected
%       eg.
%               x0=slurp('Mor3.tif') --> load Mor3 and distortion and intensity correct.
%               x0=slurp('Mor3.tif','c') --> load Mor3 into x0 but don't d&i correct.
%               x0=slurp('Mor3.tif','sc') --> treat Mor3 as signed and already d&i corrected.
%
%  Function Two - Loading a sequence of Images
%       result = slurp(prefix, index, options)
%
%       Slurp loads a set of images with indices from index.
%       If more than one image is given then dezingers them.
%       Options are the same as above.
%       Option 'd' means images are already dezingered.  Simply average.
%           eg.
%               x0=slurp('Mor',[3,4,7]) 
%                        -> Loads Mor3.tif, Mor4.tif and Mor7.tif
%                           Removes zingers, distortion and intensity corrects.
%
%               x0=slurp('Mor',[1,8:10],'c')
%                        ->  Loads Mor1.tif, Mor8.tif, Mor9.tif and Mor10.tif
%                        ->  Dezingers but does not distortion and intensity correct
%
%               x0=slurp('Mor',[1,2],'ds')
%                        ->  Loads Mor1.tif and Mor2.tif and places average in x0
%                        ->  Treats as signed tiff.
%
% Function Three - Loading a sequence of Images and subtract background images from them.
%      result - slurp(prefix, index, background_index, options)
%   
%               x0=slurp('Mor',[1,2],[20,21]) -> Dezingers and corrects Mor1.tif and Mor2.tif
%                           Does same to Mor20.tif and Mor21.tif.  x0= signal- background.
%
%               x0=slurp('Mor',[1,2],[20,21],'c') -> Same but no correction.
%
% Dependencies - dezing(), correct(), averge_tag()
% 					- You've defined correction files for your detector.

function result = slurp(varargin)

% Look for an option string and set parameters.
Correct_Images=1; Sign_Flip =0; Dezinger_Images=1;
call_mode = nargin;

if (call_mode>1)&(ischar(varargin{nargin}))
    if findstr(varargin{nargin},'c') Correct_Images=0; end
    if findstr(varargin{nargin},'s') Sign_Flip=1; end
    if findstr(varargin{nargin},'d') Dezinger_Images=0; end
    call_mode=call_mode-1;
end

% Mode One - Loading a single image. Will convert data type to double.
if (call_mode==1)
    fname = char(varargin(1));
    result=get_img(fname,Sign_Flip);
    result = double(result);
end

% Mode Two - Loading a set of images.
if (call_mode==2)
    prefix = char(varargin(1)); index = varargin{2};
    result=avg_set(prefix, index, Sign_Flip, Dezinger_Images);    
end

% Mode Three - Loading images and backgrounds.
if (call_mode==3)
    prefix = char(varargin(1)); index = varargin{2}; background_index=varargin{3};
    fg = avg_set(prefix,index,Sign_Flip,Dezinger_Images);
    bg = avg_set(prefix,background_index, Sign_Flip, Dezinger_Images);
    result = fg-bg;
end

%  Correct images if requested.
if Correct_Images
    result = correct(result);
end

function result=avg_set(prefix, index, Sign_Flip, Dezinger_Images)    
% Subfunction to read in a set of images with prefix and index.
% result returns an "average" as a double.
    z = get_img(sprintf('%s%d.tif',prefix, index(1)),Sign_Flip);
    for j=2:length(index)
        z(:,:,j)=get_img(sprintf('%s%d.tif',prefix, index(j)),Sign_Flip);
    end
    
    if (length(index)<2)
        result=double(z);
    else
        if Dezinger_Images
            z = uint16(z);
            result=dezing(z)/size(z,3);
        else
            z = double(z);
            result = sum(z,3)/size(z,3);
        end        
    end
    
    
        
function result=get_img(fname,Sign_Flip)
% Subfunction to read a single image
% Returns a uint16 or double depending on whether the image is signed.
    result = imread(fname,'tif');
    if Sign_Flip
       x=result;
       y = floor(double(x) ./ 32768);
       result = double(x).* (1-y) + y .* (65536 - double(x));
    end


