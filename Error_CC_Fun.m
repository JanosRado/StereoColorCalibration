function [ Err ] = Error_CC_Fun( x, dLum, dCont )
%Error_CC_Fun Error calculation for Correlated Dots
% Calculates the luminance error for 
% Error_CC_Fun.m These functions calculate the components of the error
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
% Bight dot through the red filter
CC_BR = feval(@EvalRA,x(3)) + feval(@EvalRC,x(4));
% Dark dot through the red filter
CC_DR = feval(@EvalRA,x(1)) + feval(@EvalRC,x(2));
% Bight dot through the green filter
CC_BG = feval(@EvalGA,x(4))  + feval(@EvalGC,x(3));
% Dark dot through the green filter
CC_DG = feval(@EvalGA,x(2))  + feval(@EvalGC,x(1));
% Contrast error on the red filter 
ContR = (CC_BR - CC_DR)/(CC_BR + CC_DR);
% Contrast error on the green filter 
ContG = (CC_BG - CC_DG)/(CC_BG + CC_DG);

% Luminance error on the red filter
LumR = (CC_BR + CC_DR)/2;
% Luminance error on the green filter
LumG = (CC_BG + CC_DG)/2;

% Error vector
Err_CC = [ (dLum - LumR)/dLum, (dLum - LumG)/dLum,...
    (dCont - ContR)/dCont, (dCont - ContG)/dCont ];
% Euclidean norm of the error vector
Err = norm(Err_CC);
end

