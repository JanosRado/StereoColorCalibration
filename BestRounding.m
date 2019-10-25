function [ BestColors ] = BestRounding( mf, dL, dC )
% This function performs rounding of digital video values to the nearest
% integer so that the overall error in luminance and contrast is minimal.
% The method is described in section "Minimizing the effect of rounding" of
% the paper.
% 
% INPUT mf: 8-element vector containing the digital video values to be
% rounded. See description of NumericConstrainSolver above for the meaning
% of each element. 
% 
% dL: required mean luminance 
% dC: required dot contrast
% 
% OUTPUT
% BestColors: 8-element vector containing the integer digital video values.


% calculate errors
blank = zeros(8,1);
rnd_mf = zeros(8,1);
rnd_mf_vect = zeros(256,8);
error_vect = zeros(256,1);
mask_vect = zeros(256,8);
% This cycle generates the 2^8 possible alternative rounding and the belonging errors 
for ii=1:256
    mask0 = de2bi(ii-1);
    mask = blank;
    mask(1:numel(mask0)) = mask0;
    mask_vect(ii,:) = mask;
    
    low_ix = find(mask==0);
    high_ix = find(mask==1);
    rnd_mf(low_ix) = floor(mf(low_ix));
    rnd_mf(high_ix) = ceil(mf(high_ix));
    rnd_mf_vect(ii,:) = rnd_mf;
    Errors = GetErrors(rnd_mf, dL, dC);
    error_vect(ii) = norm([Errors.Err_AC;Errors.Err_CC]);
end

%% round patterns for small error

M = 256;  % M smallest error
%Sorting the alternative by the magnitude of the error in increasing order
[serr_val,serr_ix] = sort(error_vect);

% good_rnd_pattern = mask_vect(serr_ix(1:M),:);
% good_errors = error_vect(serr_ix(1:M));

% The first in the list will be the best selection (i.e., smallest error)
BestColors = floor( mf) + mask_vect(serr_ix(1),:);

end

