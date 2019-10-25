function [ Err ] = Error_AC_Fun( x ,dLum, dCont)
%Error_AC_Fun Error calculation for Anticorrelated dots
% Error_AC_Fun.m These functions calculate the components of the error
% terms minimized during optimization as defined in Equations 8 and 9 of
% the paper, respectively.
% 
% INPUT x: a 4-element vector containing the digital video values for which
% the error is calculated. The 4 elements are [r_R, r_G, g_G, g_R] for
% Error_AC_Fun and [r_B, g_B, r_Y, g_Y] for Error_CC_Fun. See description
% of NumericConstrainSolver above for the meaning of each element. 
% dLum: required mean luminance 
% dCont: required dot contrast
% 
% OUTPUT Err: the error value.

% Calculates the luminance error for 
% Bight dot through the red filter
AC_BR = feval(@EvalRA,x(1)) + feval(@EvalRC,x(2));
% Dark dot through the red filter
AC_DR = feval(@EvalRA,x(4)) + feval(@EvalRC,x(3));
% Bight dot through the green filter
AC_BG = feval(@EvalGA,x(3))  + feval(@EvalGC,x(4));
% Dark dot through the green filter
AC_DG = feval(@EvalGA,x(2))  + feval(@EvalGC,x(1));

% Contrast error on the red filter 
ContR = (AC_BR - AC_DR)/(AC_BR + AC_DR);
% Contrast error on the green filter 
ContG = (AC_BG - AC_DG)/(AC_BG + AC_DG);

% Luminance error on the red filter
LumR = (AC_BR + AC_DR)/2; 
% Luminance error on the green filter
LumG = (AC_BG + AC_DG)/2;

% Error vector
Err_AC = [ (dLum - LumR)/dLum, (dLum - LumG)/dLum,...
    (dCont - ContR)/dCont, (dCont - ContG)/dCont ];

%  Euclidean norm of the error vector
Err = norm(Err_AC);
end

