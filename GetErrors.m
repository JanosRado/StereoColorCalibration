function [  Errors ] = GetErrors( x, dLum, dCont )
% GetErrors.m
% This function calculates the various error measures between a set of
% digital video values and the desired luminance and desired contrast.
% 
% INPUT
% x: 8-element vector containing the digital video values for which the
% error has to be calculated. See description of NumericConstrainSolver
% above for the meaning of each element.
% dLum: required mean luminance
% dCont: required dot contrast
% 
% OUTPUT
% Errors: structure with the following fields
% 	Predicted mean luminances following optimization (in the notation of Equation 4 of the paper)
% 	LumR_AC: L_RGrho
% 	LumG_AC: L_RGgamma
% 	LumR_CC:  L_YBrho
% 	LumG_CC: L_YBgamma
% 	Predicted Michelson contrasts following optimization (in the notation of Equation 5 of the paper)
% 	ContR_AC: C_RGrho
% 	ContG_AC: C_RGgamma
% 	ContR_CC: C_YBrho
% 	ContG_CC: C_YBgamma
% 	Components of the error terms minimized during optimization
% 	Err_AC: [e_LRGrho, e_LRGgamma, e_CRGrho, e_CRGgamma] in the notation of Equation 8 of the paper
% 	Err_CC: [e_LYBrho, e_LYBgamma, e_CYBrho, e_CYBgamma] in the notation of Equation 9 of the paper
% 	Components of the estimated strength of monocular cues (M) defined in Equation 13 of the paper
% 	Err_Ro: 1st and 3rd components
% 	Err_Gamma: 2nd and 4th components


AC_BR = feval(@EvalRA,x(1)) + feval(@EvalRC,x(2));     %AC Bright Red    
AC_DR = feval(@EvalRA,x(4)) + feval(@EvalRC,x(3));     %AC Dark Red

AC_BG = feval(@EvalGA,x(3))  + feval(@EvalGC,x(4));     %AC Bright Green
AC_DG = feval(@EvalGA,x(2))  + feval(@EvalGC,x(1));     %AC Dark Green

ContR_AC = (AC_BR - AC_DR)/(AC_BR + AC_DR);    %Contrast AC Red
ContG_AC = (AC_BG - AC_DG)/(AC_BG + AC_DG);    %Contrast AC Red

LumR_AC = (AC_BR + AC_DR)/2;   % Red luminance average
LumG_AC = (AC_BG + AC_DG)/2;   % Green luminance average

Err_AC = [ (dLum - LumR_AC)/dLum, (dLum - LumG_AC)/dLum,...
    (dCont - ContR_AC)/dCont, (dCont - ContG_AC)/dCont ];

CC_BR = feval(@EvalRA,x(7)) + feval(@EvalRC,x(8));     %AC Bright Red    
CC_DR = feval(@EvalRA,x(5)) + feval(@EvalRC,x(6));     %AC Dark Red

CC_BG = feval(@EvalGA,x(8))  + feval(@EvalGC,x(7));     %AC Bright Green
CC_DG = feval(@EvalGA,x(6))  + feval(@EvalGC,x(5));     %AC Dark Green

ContR_CC = (CC_BR - CC_DR)/(CC_BR + CC_DR);    %Contrast AC Red
ContG_CC = (CC_BG - CC_DG)/(CC_BG + CC_DG);    %Contrast AC Red

LumR_CC = (CC_BR + CC_DR)/2;   % Red luminance average
LumG_CC = (CC_BG + CC_DG)/2;   % Green luminance average

Err_CC = [ (dLum - LumR_CC)/dLum, (dLum - LumG_CC)/dLum,...
    (dCont - ContR_CC)/dCont, (dCont - ContG_CC)/dCont ];

Err_Ro =    [ ( LumR_AC - LumR_CC ) / dLum , (ContR_AC - ContR_CC)  ];
Err_Gamma = [ ( LumG_AC - LumG_CC ) / dLum , (ContG_AC - ContG_CC)  ];

Errors.LumR_AC = LumR_AC;
Errors.LumG_AC = LumG_AC;
Errors.ContR_AC = ContR_AC;
Errors.ContG_AC = ContG_AC;
Errors.Err_AC = Err_AC;
Errors.Err_Ro = Err_Ro;

Errors.LumR_CC = LumR_CC;
Errors.LumG_CC = LumG_CC;
Errors.ContR_CC = ContR_CC;
Errors.ContG_CC = ContG_CC;
Errors.Err_CC = Err_CC;
Errors.Err_Gamma = Err_Gamma;
end

