% This script makes a bitmap file, which can be used to test the result provided by the ExampleParameterSweep.m script. 
% It plots horizontal and vertical stripes taking the colors from the R structure which is the output of the
% ExampleParameterSweep script. If the image is displayed on the specific calibrated monitor and viewed through the calibrated 
% filters by one of the eyes, horizontal or vertical stripes are visible depending on which filter is used.   
% 
% INPUT
% 	- data file with the result of parameter_sweep (NxM R structure)
% 	- selected luminance level
% 	- selected contrast level
% 	- type of display (anaglyph or polar)
% 	- width of the stripe (in pixels)
% 	- image size [x,y] (in pixels)
% OUTPUT
%   - color bitmat image saved in a file called 'Anaglyph.bmp' or 'Polar.bmp'


% Color settings
% data file with the result of parameter_sweep (NxM R structure)
FileName = '..\Data\Resultp3rnd100x100201910151635.mat';
% selected luminance level
Luminance = 5;
% selected contrast level
Contrast = 0.5;

% Image settings
% DisplayType = 'Anaglyph';  %Polar or Anaglyph
DisplayType = 'Polar';  %Polar or Anaglyph

% width of the stripe (in pixels)
PatternSize = 300;
% image size [x,y] (in pixels)
ImageSize = [1920 1080];

% Get colors from file
[Colors ,ReadedLuminance,ReadedContrast]  = ReadRGBsFromFile(Luminance,Contrast,FileName);

% Get data image
ImageMx = MakeDataMatrix(DisplayType,ImageSize,PatternSize, Colors);

% save image
imwrite(ImageMx,strcat(DisplayType,'.bmp'));
