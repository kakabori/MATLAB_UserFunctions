function [] = make_sp(img_name, msp, beamx, beamy, step, mAng, type)
%This function takes an image file name for an x-ray diffrac45tion image for
%a lipid produced by the methods of Yufeng Liu and adds artificial mosaic
%spread.
%The parameter img_name gives the full path of the image to be read
%sig gives the standard deviation of the distribution
%beamx and beamy give the x and y coordinates of the beam
%step gives the step size for sweeping through rotations
%mAng is the maxiumum rotation angle to consider
%type indicates whether the distribution should be Gaussian, in which case
%a 'g' is entered, or Lorentzian, in which case an 'l' is entered. Note
%that the type parameter is not case sensitive.


%Validate distribution type
type = upper(type);
if(~(strcmp(type, 'G') || strcmp(type, 'L')))
    error('The type must be either g for Gaussian or l for lorentzian');
end

%Inline functions to define Lorentzian and Gaussian weighting factors
lorentz = inline('hwidth / (hwidth ^ 2 + x^2) / pi()', 'x', 'hwidth');
gauss = inline('exp(-x^2/ 2 / sig^2) / sig / sqrt(2*pi())', 'x', 'sig');

hwidth = msp/2;
sig = msp/2.35482;

%Read in specified image and enusre  it is stored in single precision floating
%point form and contains no instances of NaN.
img = imread(img_name);
img = to_single(img);
img = remove_nan(img);

%Figure out difference between the image center and the beam position
[rows cols] = size(img);
xoffset = floor(rows/2 - beamx);
yoffset = floor(beamy - cols/2);

%Apply a weighting factor to the initial image, and make it the first
%constribution to the final composition
if(strcmp(type, 'L'))
    composition = img * lorentz(0, hwidth);
else
    composition = img * gauss(0, sig);
end

%Iterate over the specified range of rotations
i = step;
while i <= mAng
    %Find the appropriate sacling factor, governed by the choice of 
    %distribution
    if(strcmp(type, 'L'))
        scalefactor = lorentz(i, hwidth);
    else
        scalefactor = gauss(i, sig);
    end

    %Rotate the image about its center, then use a linear translation to
    %shift the center of rotation to the specified beam position
    temprot = immultiply(imrotate(img, i), scalefactor);
    xdiff = -xoffset*(1-cos(i*pi()/180)) - yoffset*sin(i*pi()/180);
    ydiff = (yoffset*(1-cos(i*pi()/180)) + xoffset*sin(i*pi()/180));
    [trows tcols] = size(temprot);
    trans = maketform('affine', [1, 0, 0;0, 1, 0;xdiff, ydiff, 1]);
    temprot = imtransform(temprot, trans, 'XData', [1, trows], 'YData', [1 tcols]);
    %Ensure that temprot uses the correct numerical format, and add it to the
    %running sum of rotation contributions
    temprot = cast(temprot, 'single');
    composition = imadd_augmented(composition, temprot);
    
    %Repeat the process, but this time rotate in the clockwise direction
    temprot = immultiply(imrotate(img, -i), scalefactor);
    xdiff = -xoffset*(1-cos(-i*pi()/180)) - yoffset*sin(-i*pi()/180);
    [trows tcols] = size(temprot);
    trans = maketform('affine', [1, 0, 0;0, 1, 0;xdiff, ydiff, 1]);
    temprot = imtransform(temprot, trans, 'XData', [1, trows], 'YData', [1 tcols]);
    temprot = cast(temprot, 'single');
    composition = imadd_augmented(composition, temprot);
    i = i + step;
end

%Crop the image by defining a 1024 by 1024 square in the center of the
%composition of rotations
[rows cols] = size(composition);
xmin = floor((rows - 1024) / 2);
ymin = floor((cols - 1024) / 2);
composition = imcrop(composition, [xmin, ymin, 1023, 1023]);

%Use a regular expression to trim the .tif file extension from the input name,
%then add a label to the end of the original name with details about the run,
%followed by the .tif extension to create the output file name.
match = regexp(img_name, '[^\.]+', 'match');
basename = char(match(1, 1));
outname = sprintf('%s_%2.2f_%1.3f_%2.0f_%c.tif', basename, msp, step, mAng, type);
fprintf('Writing %s\n', outname);
%Create output TIFF object, set necessary TIFF tags, and write to a file
outTiff = Tiff(outname, 'w');
%Identify the image as grayscale
outTiff.setTag('Photometric', 1);
%Give the size of individual data points
outTiff.setTag('BitsPerSample', 32);
%Indicate that ther is only one channel per pixel
outTiff.setTag('SamplesPerPixel', 1);
%Give image dimensions
outTiff.setTag('ImageLength', 1024);
outTiff.setTag('ImageWidth', 1024);
outTiff.setTag('PlanarConfiguration', 1);
%Indicate the numerical format as IEEE floating point
outTiff.setTag('SampleFormat', 3);
outTiff.write(composition);
outTiff.close();
end
