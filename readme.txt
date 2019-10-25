These files accompany the publication “Calibration of random dot stereograms and correlograms free of monocular cues” by János Radó, Zoltán Sári, Péter Buzás and Gábor Jandó, published in Journal of Vision in 2019.

The Matlab code provided here is the implementation of the numerical method described in the paper.

With questions related to the program code, please contact János Radó (e-mail: janos.rado@aok.pte.hu).

The corresponding author for the paper is Péter Buzás (e-mail: peter.buzas@aok.pte.hu).

*******************************
PROJECT SUMMARY
*******************************
Dynamic random dot stereograms (DRDSs) and correlograms (DRDCs) are cyclopean stimuli containing binocular depth cues that are ideally, invisible by one eye alone. Thus, they are important tools in assessing stereoscopic function in experimental or ophthalmological diagnostic settings. However, widely used filter-based 3D display technologies often cannot guarantee complete separation of the images intended for the two eyes. Without proper calibration, this may result in unwanted monocular cues in DRDSs and DRDCs, which may bias scientific or diagnostic results. Here, we employ a simple mathematical model describing the relationship of digital video values and average luminance and dot contrast in the two eyes. We present an optimization algorithm that provides the set of digital video values that achieve minimal crosstalk at user-defined average luminance and dot contrast for both eyes based on photometric characteristics of a given display. We demonstrated in a psychophysical experiment with color normal participants that this solution is optimal because monocular cues were not detectable at either the calculated or the experimentally measured optima. We also explored the error by which a range of luminance and contrast combinations can be implemented. Although we used a specific monitor and red-green glasses as an example, our method can be easily applied for other filter based 3D systems. This approach is useful for designing psychophysical experiments using cyclopean stimuli for a specific display.

*******************************
QUICK INTRODUCTION
*******************************

The simplest way to try out the numerical solution described in the paper on a real example is to run the script ExampleCalibration.m as is. This script uses the luminance data (in cd/m^2) measured for our LG Cinema 3D monitor. You can also change the desired mean luminance and the dot contrast within the script if you wish. It then provides the digital video values of the red and green phosphors that have to be used to present the 4 logical colors (Red, Green, Black, Yellow).

Important note: If you want to use this program for your experiment, you have to measure the luminance characteristics of your own monitor trough each filter used in the goggles and store these data in similar MATLAB data files as those found in the Data directory.

Another example is provided in the script ExampleParameterSweep. This is an extended version of the previous script because it works out the color settings of the logical colors for a set of mean luminances and dot contrasts. It will also plot color coded maps of the calculated errors in luminance and contrast as shown in Figures 6C and D of the paper.

At the heart of both of these examples is the function NumericConstrainSolver, which performs the actual nonlinear optimization based on the luminance characteristics ("gamma curves") of the monitor phosphors and the required mean luminance and contrast.

*******************************
DETAILED INFORMATION ON FILES IN THIS MATLAB PROJECT
*******************************

ExampleCalibration.m
This script uses the data measured for our LG Cinema 3D monitor. The script provides the digital video values of the red and green phosphors that have to be used to present the 4 logical colors (Red, Green, Black, Yellow) of an anaglyphic DRDS or DRDC having specific mean luminance and dot contrast and no monocular cues.

INPUT
The luminance characteristics ("gamma curves") of the monitor phosphors measured through the red or green filters must be saved as mat-files beforehand. Two files have to be provided, one for the red filter and another for the green filter. Each mat file must contain a matrix as described below for the function FitLuminanceCharacteristics.

You can also define the type of function fitted to the luminance characteristics. See details in the description of FitLuminanceCharacteristics below.

The required mean luminance and dot contrast are defined within the script.

OUTPUT
The results of the calibration are stored in the structure variable R, which contains all the fields passed back by NumericConstrainSolver (see below) and additionally, the following fields:

BestRGBs: calibrated digital video values, each rounded to the nearest integer so that the overall error is minimal. See details below for the function BestRounding.

BestRGBsErrors: Predicted mean luminances, contrasts and their error after rounding in the same format as described for the field R.Errors in the output of NumericConstrainSolver.

*******************************

ExampleParameterSweep.m
This script runs through a range of required luminance and contrast combinations and calculates calibrated digital video values at double-precision for each combination. The same inputs are required as in ExampleCalibration above. In addition, the range and resolution of required luminances and contrasts are defined within the script.

The output is provided in the N-by-M structure R, where each element follows the format described above for the output of ExampleCalibration; N and M are the numbers of luminance and contrast steps, respectively. We also save R into a mat-file whose name is constructed from parameters of the current run and a time stamp.

The script also plots the calculated errors in luminance and contrast as shown in Figure 6C and D of the paper, which is helpful in judging the range of luminances and contrasts feasible on a specific monitor-filter combination.

*************************

NumericConstrainSolver.m
This is the function that performs the nonlinear optimization, which we call "numerical solution" in the paper.

INPUT
dL: required mean luminance
dC: required dot contrast
fitting: A global structure variable describing the functions that approximate the luminance characteristics ("gamma curves"). See details below under the function FitLuminanceCharacteristics.

OUTPUT
R: A structure variable with the following fields:
bestfit: 8-element vector containing the calibrated digital video values at double-precision. The elements are as follows:
	r_R: digital video value of red component of logical red color
	r_G: digital video value of red component of logical green color
	g_G: digital video value of green component of logical green color
	g_R: digital video value of green component of logical red color
	r_B: digital video value of red component of logical black color
	g_B: digital video value of green component of logical black color
	r_Y: digital video value of red component of logical yellow color
	g_Y: digital video value of green component of logical yellow color.
res_err: this value is not used in the present example
StartingPoint: starting point of the optimization in the same format as bestfit.
Errors: structure with the fields reporting various error measures used in the paper. See details under the function GetErrors below.

*******************************

FitLuminanceCharacteristics.m
This function fits a user defined model to the measured luminance characteristics ("gamma curves") of the monitor to be calibrated.

INPUT
LuminancesRedFilt, LuminancesGreenFilt: file name of mat files containing the luminance characteristics measured through the red and green filters, respectively. These data must be in the saved variable measured_L_curves, which has the following format:
	Column 1: the digital video values where the measurements were made.
	Columns 2-3: luminance values for the red and green phosphors, respectively, at the levels defined in Column 1.
FittingType: Type of function to be fitted. Currently implemented are ' p3rnd' (3rd order polynomial) and 'gamma' (power function often called the "gamma function"). Further models can be implemented easily based on these examples.
FittingFeedback: If true, the curve fits are plotted and goodness of fit measures are saved in an Excel file in the current directory.

OUTPUT
A structure with 4 fields, each containing curve fitting objects produced by the fit.m function in the Matlab Curve Fitting Toolbox. The four fields RA, RC, GC, GA correspond to p_rrho (Red Attenuation), p_rgamma (Red Crosstalk), p_ggamma (Green Attenuation) and p_grho (Green Crosstalk), respectively.

*************************

InitializesStartingPoint.m
This function initializes the starting point of the nonlinear optimization performed by the fmincon function.

INPUT
dL, dC, fitting: as described for NumericConstrainSolver.

OUTPUT
sp: starting point of the optimization in an 8-element vector as described for NumericConstrainSolver.

*************************

Error_AC_Fun.m and Error_CC_Fun.m
These functions calculate the components of the error terms minimized during optimization as defined in Equations 8 and 9 of the paper, respectively.

INPUT
x: a 4-element vector containing the digital video values for which the error is calculated. The 4 elements are [r_R, r_G, g_G, g_R] for Error_AC_Fun and [r_B, g_B, r_Y, g_Y] for Error_CC_Fun. See description of NumericConstrainSolver above for the meaning of each element.
dLum: required mean luminance
dCont: required dot contrast

OUTPUT
Err: the error value.

*************************

BestRounding.m
This function performs rounding of digital video values to the nearest integer so that the overall error in luminance and contrast is minimal. The method is described in section "Minimizing the effect of rounding" of the paper.

INPUT
mf: 8-element vector containing the digital video values to be rounded. See description of NumericConstrainSolver above for the meaning of each element.
dL: required mean luminance
dC: required dot contrast

OUTPUT
BestColors: 8-element vector containing the integer digital video values.

*************************

GetErrors.m
This function calculates the various error measures between a set of digital video values and the desired luminance and desired contrast.

INPUT
x: 8-element vector containing the digital video values for which the error has to be calculated. See description of NumericConstrainSolver above for the meaning of each element.
dLum: required mean luminance
dCont: required dot contrast

OUTPUT
Errors: structure with the following fields.
	Predicted mean luminances following optimization (in the notation of Equation 4 of the paper)
	LumR_AC: L_RGrho
	LumG_AC: L_RGgamma
	LumR_CC: L_YBrho
	LumG_CC: L_YBgamma
	Predicted Michelson contrasts following optimization (in the notation of Equation 5 of the paper)
	ContR_AC: C_RGrho
	ContG_AC: C_RGgamma
	ContR_CC: C_YBrho
	ContG_CC: C_YBgamma
	Components of the error terms minimized during optimization
	Err_AC: [e_LRGrho, e_LRGgamma, e_CRGrho, e_CRGgamma] in the notation of Equation 8 of the paper
	Err_CC: [e_LYBrho, e_LYBgamma, e_CYBrho, e_CYBgamma] in the notation of Equation 9 of the paper
	Components of the estimated strength of monocular cues (M) defined in Equation 13 of the paper
	Err_Ro: 1st and 3rd components
	Err_Gamma: 2nd and 4th components

*************************

EvalRA.m, EvalRC.m, EvalGA.m and EvalGC.m

These functions return the luminance of the red or green monitor phosphor as seen through the red or green filter by evaluating the model functions generated by FitLuminanceCharacteristics. The model functions must be stored as fit objects in the global variable fitting. The four functions evaluate p_rho (Red Attenuation), p_rgamma (Red Crosstalk), p_ggamma (Green Attenuation) and p_grho (Green Crosstalk), respectively.

Input x is the digital video value and output y is the luminance.

*************************

DIRECTORY Data
This directory is the default location for data and results. Inside, there are two examples of measured data and a result file for testing purposes.

LuminancesRedFilt.mat and LuminancesGreenFilt.mat each contain the saved variable measured_L_curves storing the measured luminance characteristics (in cd/m^2) through the red and green filters, respectively. The content of these files is described for the function FitLuminanceCharacteristics above.

Resultp3rnd100x100201910151635.mat is a result file generated by ExampleParameterSweep.

*************************

DIRECTORY ExampleOfUsingParameterSweepResult

ExampleArtefactTester.m
This script makes a test bitmap, which can be used to test the result provided by the ExampleParameterSweep.m script. If the image is displayed on the specific calibrated monitor and viewed through the calibrated filters by one of the eyes, horizontal or vertical stripes are visible depending on which filter is used. The colors of the bitmap are taken from a pre-calculated R structure which is the output of the ExampleParameterSweep script.

The following inputs are specified within the script:
Data file with the result of parameter_sweep (NxM R structure).
Required luminance and contrast levels.
Type of display (anaglyph or polar).
Width of the stripes (in pixels).
Image size [x,y] (in pixels)

OUTPUT
Color bitmap image saved in a file called “Anaglyph.bmp” or “Polar.bmp”.

*************************

ReadRGBsFromFile.m
This function selects the calibrated RGB values for a luminance and contrast combination from a file containing pre-calculated result of a parameter sweep such as ExampleParameterSweep.m. If the exact luminance and contrast combination is not found, then the closest one is selected.

INPUT
DesiredLuminance: required luminance level.
DesiredContrast: required contrast level.
FileName: data file with the result of the parameter_sweep (ExampleParameterSweep.m).

OUTPUT
RGBs: 8-element vector containing the integer digital video values.
ExactLuminance: the closest luminance level to the required value.
ExactContrast: the closest contrast level to the required value.

*************************

MakeDataMatrix.m 
This function calculates the RGB colors of the test bitmap.

INPUT
Type: Type of display technique ('Anaglyph' or 'Polar') where the picture will be tested.
ImageSize: The image size [x,y] (in pixels).
PatternSize: width or height of the stripe (in pixels).
Colors: 8-element vector containing the integer digital video values.

OUTPUT
DataMX: A 3D matrix with the RGB values of the picture.

*************************

GetColorMap.m
This function converts the output of the optimization (8-element vector of digital video values) into a colormap that can be used for presenting the test bitmap images.

INPUT
Type: Type of display technique ('Anaglyph' or 'Polar') where the picture will be tested.
Colors: 8-element vector containing the integer digital video values.

OUTPUT
ColorMap: a Matlab colormap (type "help colormap" in Matlab for a definition). Its content depends on the display technology.
       If Type is 'Anaglyph', then it is a matrix of 5 rows. The first 4 contain the RGB values of anaglyph logical colors in the order Black, Red, Green Yellow. The last row is not used in this project.
       If Type is 'Polar', then ColorMap is a structure with fields Left and Right, each of which contains the colormaps intended for the respective eye channels of the monitor. The last row is not used in this project.

*******************************
NOTE FOR USERS OF 3D MONITORS USING POLAR FILTERS
*******************************

The algorithm can be applied for polar 3D monitors. For simplicity, we give an example where greyscale images are presented to both eyes, i.e. where the R, G and B digital video values are equal.

1. The luminance characteristics have to be supplied as follows:
LuminancesRedFilt.mat must contain measurements taken through the left filter.
	Column 1: the greyscale values where the measurements were made, e.g. 0..255.
	Column 2: luminance values when the greyscale image is presented on the monitor channel intended for the left eye. This is called the "filter attenuation" in the paper.
	Column 3: luminance values when the greyscale image is presented on the monitor channel intended for the right eye. This is called the "filter crosstalk" in the paper.

LuminancesGreenFilt.mat must contain measurements for the right filter
	Column 1: the greyscale values where the measurements were made, e.g. 0..255.
	Column 2: luminance values when the greyscale image is presented on the monitor channel intended for the left eye. This is called the "filter crosstalk" in the paper.
	Column 3: luminance values when the greyscale image is presented on the monitor channel intended for the right eye. This is called the "filter attenuation" in the paper.

2. The 8-element vector supplied by the numerical optimizer (NumericConstrainSolver) should be interpreted as follows. Brightness of the dots in the two eyes is given in parentheses as (left eye brightness, right eye brightness).
	r_R: grayscale value to be presented on the left  eye channel for (bright, dark) dots
	r_G: grayscale value to be presented on the left  eye channel for (dark,   bright) dots
	g_G: grayscale value to be presented on the right eye channel for (dark,   bright) dots
	g_R: grayscale value to be presented on the right eye channel for (bright, dark) dots
	r_B: grayscale value to be presented on the left  eye channel for (dark,   dark) dots
	g_B: grayscale value to be presented on the right eye channel for (dark,   dark) dots
	r_Y: grayscale value to be presented on the left  eye channel for (bright, bright) dots
	g_Y: grayscale value to be presented on the right eye channel for (bright, bright) dots


************************* END *************************
