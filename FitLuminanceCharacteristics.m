function [fitting] = FitLuminanceCharacteristics(LuminancesRedFilt , LuminancesGreenFilt , FittingType , FittingFeedback)
% This function fits a user defined model to the measured luminance
% characteristics ("gamma curves") of the monitor to be calibrated.
% 
% INPUT
% 
% LuminancesRedFilt, LuminancesGreenFilt: path and file name of mat files
% containing the luminance characteristics measured through the red and
% green filters, respectively. These data must be in variable
% measured_L_curves, which has the following format:
% 	Column 1: the digital video values where the measurements were made.
% 	Columns 2-3: luminance values for the red and green phosphors,
% 	respectively, at the levels defined in Column 1. Additional columns (if
% 	they exist) are disregarded in the current project.
% FittingType: Type of function to be fitted. Currently implemented are
% 'p3rnd' (3rd order polynomial) and 'gamma' (power function often called
% the "gamma function"). Further models can be implemented easily based on
% these examples.
% FittingFeedback: If true, the curve fits are plotted and goodness of fit
% measures are saved in an Excel file in the current directory.
% 
% OUTPUT
% 
% A structure with 4 fields, each containing curve fitting objects produced
% by the fit.m function in the Matlab Curve Fitting Toolbox. The four
% fields RA, RC, GC, GA correspond to p_rrho (Red Attenuation), p_rgamma
% (Red Crosstalk), p_ggamma (Green Attenuation) and p_grho (Green
% Crosstalk), respectively.


load(LuminancesRedFilt);
MeasuredDataWithRedFilter = measured_L_curves;
load(LuminancesGreenFilt);
MeasuredDataWithGreenFilt = measured_L_curves;
graylevels = MeasuredDataWithGreenFilt(:,1);

if FittingType == 'p3rnd'
    Equation = 'a*x^3+b*x^2+c*x+d';
    [fitting.RA , gof.RA , FittingOutput.RA] = fit(graylevels,MeasuredDataWithRedFilter(:,2),Equation);  %redfilt-R
    [fitting.RC , gof.RC , FittingOutput.RC] = fit(graylevels,MeasuredDataWithRedFilter(:,3),Equation);    %redfilt-G
    [fitting.GC , gof.GC , FittingOutput.GC] = fit(graylevels,MeasuredDataWithGreenFilt(:,2),Equation);    %greenfilt-R
    [fitting.GA , gof.GA , FittingOutput.GA] = fit(graylevels,MeasuredDataWithGreenFilt(:,3),Equation);    %greenfilt-G
end



if FittingType == 'gamma'
Equation = 'a*power(x,b)+c';
[fitting.RA , gof.RA , FittingOutput.RA] =  fit(graylevels,MeasuredDataWithRedFilter(:,2),Equation,'Lower',[0,0,0]);
[fitting.RC , gof.RC , FittingOutput.RC] =  fit(graylevels,MeasuredDataWithRedFilter(:,3),Equation,'Lower',[0,0,0]);
[fitting.GC , gof.GC , FittingOutput.GC] =  fit(graylevels,MeasuredDataWithGreenFilt(:,2),Equation,'Lower',[0,0,0]);
[fitting.GA , gof.GA , FittingOutput.GA] =  fit(graylevels,MeasuredDataWithGreenFilt(:,3),Equation,'Lower',[0,0,0]);
end

% if you want to use your own custom defined function for the monitor characteristic the only things you have to mondity
% in the source code are the your_function_name and your_function
%
% if FittingType == 'your_function_name'
%     Equation = 'your_function'; %in a form of 'a*x+b+ ... ';
%     [fitting.RA , gof.RA , FittingOutput.RA] = fit(graylevels,MeasuredDataWithRedFilter(:,2),Equation);  %redfilt-R
%     [fitting.RC , gof.RC , FittingOutput.RC] = fit(graylevels,MeasuredDataWithRedFilter(:,3),Equation);    %redfilt-G
%     [fitting.GC , gof.GC , FittingOutput.GC] = fit(graylevels,MeasuredDataWithGreenFilt(:,2),Equation);    %greenfilt-R
%     [fitting.GA , gof.GA , FittingOutput.GA] = fit(graylevels,MeasuredDataWithGreenFilt(:,3),Equation);    %greenfilt-G
% end

if FittingFeedback
    T(1,:) = struct2table(gof.RA);
    T(2,:) = struct2table(gof.RC);
    T(3,:) = struct2table(gof.GA);
    T(4,:) = struct2table(gof.GC);
    T.Properties.RowNames = {'RA' 'RC' 'GA' 'GC'};
    T.Properties.DimensionNames{1} = 'Curve';
    writetable(T,['Gof' FittingType '.xls'],'WriteRowNames',true);
    
    
    figure;
    subplot(2,2,1),hold on;
    
    plot(graylevels,MeasuredDataWithRedFilter(:,2),'r.');
    plot(graylevels,feval(fitting.RA,graylevels),'k');
    title('p_r_\rho (Red Attenuation)');
    ylabel('Luminance (cd/m^2)');
    xlim([0 255]);
    
    subplot(2,2,4);hold on;
    plot(graylevels,MeasuredDataWithRedFilter(:,3),'g.');
    plot(graylevels,feval(fitting.RC,graylevels),'k');
    title('p_g_\rho (Green Crosstalk)');
    xlabel('Digital video value');
    xlim([0 255]);
    
    subplot(2,2,2);hold on;
    plot(graylevels,MeasuredDataWithGreenFilt(:,3),'g.');
    plot(graylevels,feval(fitting.GA,graylevels),'k');
    title('p_g_\gamma (Green Attenuation)');
    xlim([0 255]);

    
    subplot(2,2,3);hold on;
    plot(graylevels,MeasuredDataWithGreenFilt(:,2),'r.');
    plot(graylevels,feval(fitting.GC,graylevels),'k');
    title('p_r_\gamma (Red Crosstalk)');
    ylabel('Luminance (cd/m^2)');
    xlabel('Digital video value');
    xlim([0 255]);
end

end

