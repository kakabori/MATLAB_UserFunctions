function [ ] = untitled2( composition, outname )
%composition, for legacy reasons, is the name of the matrix containing
%grayscale image data to be written to a TIFF file.
%outname is the name of the file to which the image should be written


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

