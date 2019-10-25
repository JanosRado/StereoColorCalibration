% This script runs through a range of required luminance and contrast
% combinations and calculates calibrated digital video values at
% double-precision for each combination. The same inputs are required as in
% ExampleCalibration above. In addition, the range and resolution of
% required luminances and contrasts are defined within the script.
% 
% The output is provided in the N-by-M structure R, where each element
% follows the format described above for the output of ExampleCalibration;
% N and M are the numbers of luminance and contrast steps, respectively. We
% also save R into a mat-file whose name is constructed from parameters of
% the current run and a time stamp.
% 
% The script also plots the calculated errors in luminance and contrast as
% shown in Figure 6C and D of the paper, which is helpful in judging the
% range of luminances and contrasts feasible on a specific monitor-filter
% combination.



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

% Read measurment data and fitting
fitting = FitLuminanceCharacteristics(LuminancesRedFiltData, LuminancesGreenFiltData, FittingType , FittingFeedback);


%% Set the luminance and contrast range for parameter sweep

% Maximum value of investigated luminance
LEnd = 13;
% Number of steps  investigated luminance
LStep = 3;
% Minimum value of investigated luminance
LFrom = LEnd/LStep;
% Investigated luminances
dL =  LFrom:(LEnd-LFrom)/(LStep-1):LEnd;
% Maximum value of investigated luminance 1 is the 100%
CEnd = 1; 
% Number of steps  investigated contrast
CStep = 3;
% Minimum value of investigated contrast
CFrom = CEnd/CStep;
% Investigated contrast
dC = CFrom:(CEnd-CFrom)/(CStep-1):CEnd;


%% Loop of parameter sweep
tic
for j = 1:numel(dL)
    disp(j);
    for  i = 1:numel(dC)
        RR = NumericConstrainSolver(dL(j),dC(i)); % Call the solver
        % store the investidated luminance
        RR.dLum = dL(j);
        % store the investidated contrast
        RR.dCont = dC(i);
        % Round digital video values to nearest integers that result in the
        % smallest overall error
        RR.BestRGBs = BestRounding(RR.bestfit,dL(j),dC(i));
        % Calculate errors after rounding
        RR.BestRGBsErrors = GetErrors(RR.BestRGBs,dL(j),dC(i));
        R(j,i) = RR; % Store the structure into R stucture array
    end
end
toc

% save result
c = clock;
save(['Data\Result'  FittingType num2str(LStep) 'x' num2str(CStep)...
    num2str(c(1))  num2str(c(2)) num2str(c(3))...
    num2str(c(4)) num2str(c(5))  '.mat'],'R');

% Plot result

% Define color axis limits
cLarge = 4;

% Upper limit of error (in log10 scale)
errUpperLim =  0;
CStepp = 0.0938;

% Calulate Error surfaces
NumberOfLuminanceData = size(R,1);
NumberOfContrstData = size(R,2);
Err_Lum = NaN(NumberOfLuminanceData,NumberOfContrstData);
Err_Cont = NaN(NumberOfLuminanceData,NumberOfContrstData);


for i=1:NumberOfLuminanceData
    for j=1:NumberOfContrstData
       Err_Lum(i,j)  = norm([R(i,j).BestRGBsErrors.Err_AC(1:2),R(i,j).BestRGBsErrors.Err_CC(1:2)]);
       Err_Cont(i,j) = norm([R(i,j).BestRGBsErrors.Err_AC(3:4),R(i,j).BestRGBsErrors.Err_CC(3:4)]);
    end
end


log_Err_Lum = log10(Err_Lum);
log_Err_Cont = log10(Err_Cont);



%% Plot Error surfaces
maxLum = R(end,end).dLum;
lum_axis = linspace(maxLum/NumberOfLuminanceData,maxLum,NumberOfLuminanceData);
maxCon = R(end,end).dCont;
con_axis = linspace(maxCon/NumberOfContrstData,maxCon,NumberOfContrstData);


% % Luminance errors
figure;
[~,h] = ContourfWithDifferentSize(con_axis,lum_axis,log_Err_Lum);

%prepare colormap
jet0 = colormap('jet');
grid on;
c = colorbar;
h.LevelList = -cLarge:CStepp:errUpperLim;
c.Limits = [-cLarge errUpperLim];
c.TickLabels = {'10^-^4','','10^-^3','','10^-^2','','10^-^1','','10^0'};
colormap(jet0);
caxis(gca,[-cLarge errUpperLim]);
ylabel('luminance (cd/m^2)');
xlabel('Michelson contrast');
title('Luminance(RND) Error Contour');
ylabel(c, 'E_L');


% Contrast errors
figure;
[~,h] = ContourfWithDifferentSize(con_axis,lum_axis,log_Err_Cont);
grid on;
c = colorbar;
h.LevelList = -cLarge:CStepp:errUpperLim;
c.Limits = [-cLarge errUpperLim];
c.TickLabels = {'10^-^4','','10^-^3','','10^-^2','','10^-^1','','10^0'};
colormap(jet0);
caxis(gca,[-cLarge errUpperLim]);
xlabel('Michelson contrast');
ylabel('luminance (cd/m^2)');
title('Contrast(RND) Error Contour');
ylabel(c, 'E_C');

function [C,h] = ContourfWithDifferentSize(con_axis,lum_axis,log_Err_Lum)
% draws contour plots

LengthCon = length(con_axis);
LengthLum = length(lum_axis);

log_Err_Lum(isinf(log_Err_Lum)) = NaN;

if LengthCon==LengthLum
[C,h] = contourf(con_axis,lum_axis,log_Err_Lum,'LineStyle','none');
else    
    if LengthCon<LengthLum
        dc = con_axis(end)-con_axis(end-1);
        diffSize = LengthLum-LengthCon;
        con_axis2 = [con_axis con_axis(end)+dc:dc:con_axis(end)+diffSize*dc]  ;
        log_Err_Lum = [log_Err_Lum NaN(LengthLum,LengthLum-LengthCon)];
        [C,h] = contourf(con_axis2,lum_axis,log_Err_Lum,'LineStyle','none');
        xlim([con_axis(1) con_axis(LengthCon)]);
    else
        dl = lum_axis(end)-lum_axis(end-1);
        diffSize = LengthCon-LengthLum;
        lum_axis2 = [lum_axis lum_axis(end)+dl:dl:lum_axis(end)+diffSize*dl]  ;
        log_Err_Lum = [log_Err_Lum ; NaN(LengthCon-LengthLum,LengthCon )];
        [C,h] = contourf(con_axis,lum_axis2,log_Err_Lum,'LineStyle','none');
        ylim([lum_axis(1) lum_axis(LengthLum)]);
    end
    
end    
end
