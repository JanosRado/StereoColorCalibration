% ExampleCalibration.m 
% This example demonstrates how the munerical solution
% works This script uses the data measured for our LG Cinema 3D monitor.
%   Measured luminance data for each DAC (not necessary to measure for all
%   DACs) through the red filter see Data\LuminancesRedFilt.mat 
%   Measured luminance data for each DAC (not necessary to measure for
%   ll DACs) through the green filter see Data\LuminancesGreenFilt.mat 
% 
% The script  provides the digital video values of the red and green
% phosphors that have to be used to present the 4 logical colors (Red,
% Green, Black, Yellow) of an anaglyphic DRDS or DRDC having specific mean
% luminance and dot contrast and no monocular cues.
% 
% INPUT The luminance characteristics ("gamma curves") of the monitor
% phosphors measured through the red or green filters must be saved as
% mat-files beforehand. Two files have to be provided, one for the red
% filter and another for the green filter. Each mat file must contain a
% matrix as described below at function FitLuminanceCharacteristics.
% 
% You can also define the type of function fitted to the luminance
% characteristics. See details in the description of
% FitLuminanceCharacteristics below.
% 
% The required mean luminance and dot contrast are defined within the
% script.
% 
% OUTPUT The results of the calibration are stored in the structure
% variable R, which contains all the fields passed back by NumConstrSolver
% (see below) and additionally, the following fields:
% 
% BestRGBs: calibrated digital video values, each rounded to the nearest
% integer so that the overall error is minimal. See details below at
% function BestRounding.
% 
% BestRGBsErrors: Predicted mean luminances, contrasts and their error
% after rounding in the same format as described for the field R.Errors.

clear all;
global fitting;


% File names where luminance characteristics ("gamma curves") are saved
LuminancesRedFiltData = 'Data\LuminancesRedFilt.mat';
LuminancesGreenFiltData = 'Data\LuminancesGreenFilt.mat';


% Fit model function to approximate luminance characteristics

% Choose model function
FittingType = 'p3rnd';   % 3rd order polynomial
% FittingType = 'gamma';  % gamma function

FittingFeedback = true; % If true, plot the result of fitting and creates Excel table of goodness of fit data.

% Read measurment data and fitting the selected function (i.e., 3rd order polynom or gamma ) to the
% data
fitting = FitLuminanceCharacteristics(LuminancesRedFiltData, LuminancesGreenFiltData, FittingType , FittingFeedback);


% Required luminance and contrast
dLum = 5;   % Desired luminance
dCont = 0.5;    % Desired contrast

% Call the solver which finds the best set (8) of of RG values
R = NumericConstrainSolver(dLum, dCont);

% Round digital video values to nearest integers that result in the
% smallest overall error
R.BestRGBs = BestRounding(R.bestfit,dLum,dCont);
% Calculate errors after rounding
R.BestRGBsErrors = GetErrors(R.BestRGBs,dLum,dCont);
% Display the results (8 RG values, actual luminances, contrsts and belonging ratio of errors deviating from the desired luminance and contrast)
disp(R);