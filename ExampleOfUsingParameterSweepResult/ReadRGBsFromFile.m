function [RGBs ,ExactLuminance,ExactContrast] = ReadRGBsFromFile(DesiredLuminance,DesiredContrast, FileName)
% This function selects the calibrated RGB values for a luminance and
% contrast combination from a file containing pre-calculated result of a
% parameter sweep such as ExampleParameterSweep.m. If the exact luminance
% and contrast combination is not found, then the closest one is selected.
% 
% INPUT
%   - DesiredLuminance: required luminance level.
%   - DesiredContrast: required contrast level.
%   - FileName: data file with the result of parameter_sweep (NxM structure
% variable R).
% 
% OUTPUT
%   - RGBs: 8-element vector containing the integer digital video values.
%   - ExactLuminance: the closest luminance level to the required value.
%   - ExactContrast: the closest contrast level to the required value.



% Get varibale info
variableInfo = who('-file', FileName);

if ~ismember('R', variableInfo)
    ME = MException('MyComponent:noSuchVariable','Variable %s not found','R');
    throw(ME);
end

fResult = load(FileName);
R = fResult.R;

% check R properties
if ~isfield(R,'dLum') || ~isfield(R,'dCont') || ~isfield(R,'BestRGBs')
    ME = MException('MyComponent:noSuchVariable','Variable %s not found','R');
    throw(ME);
end

LVect = [R(:,1).dLum];
CVect = [R(1,:).dCont];
[~,LIX] = min(abs((LVect-DesiredLuminance)));
[~,CIX] = min(abs((CVect-DesiredContrast)));
RGBs = R(LIX,CIX).BestRGBs;
ExactLuminance = R(LIX,CIX).dLum;
ExactContrast = R(LIX,CIX).dCont;
end

