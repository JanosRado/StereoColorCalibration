function [ R ] = NumericConstrainSolver( dL, dC)
% NumericConstrainSolver.m This is the function that performs the nonlinear
% optimization, which we call "numerical solution" in the paper.
% 
% INPUT dL: required mean luminance dC: required dot contrast fitting: A
% global structure variable describing the functions that approximate the
% luminance characteristics ("gamma curves"). See details below at function
% FitLuminanceCharacteristics.
% 
% OUTPUT R: A structure variable with the following fields: bestfit:
% 8-element vector containing the calibrated digital video values at
% double-precision. The elements are as follows:
% 	r_R: digital video value of red component of logical red color r_G:
% 	digital video value of red component of logical green color g_G:
% 	digital video value of green component of logical green color g_R:
% 	digital video value of green component of logical red color r_B:
% 	digital video value of red component of logical black color g_B:
% 	digital video value of green component of logical black color r_Y:
% 	digital video value of red component of logical yellow color g_Y:
% 	digital video value of green component of logical yellow color.
% res_err: this value is not used in the present example StartingPoint:
% starting point of the optimization in the same format as bestfit Errors:
% structure with the fields reporting the various error measures used in
% the paper. See details at function GetErrors

StartingPoint = InitializesStartingPoint(dL,dC);

N = 1;  %number of times optimizer is running (in case of several
        %different sets of initial values), default:1
res_x = NaN(N,8);
res_err = NaN(N,1);
opts = optimset('Display','off','TolFun',1e-6,...
    'TolX',1e-10,'FunValCheck','on');


% Constraint data
lb = zeros(4,1);
ub = 255*ones(4,1);

% function handlers for passing extra parameters
f_AC = @(x)Error_AC_Fun(x,dL,dC);
f_CC = @(x)Error_CC_Fun(x,dL,dC);

for i=1:N
    % optim
    th = 1;
    x0 = StartingPoint + th-rand(1,8)*2*th;
    [x_AC,fval_AC,~,~] = fmincon(f_AC,x0(1:4),[],[],...
        [],[],lb,ub,[],opts);
    [x_CC,fval_CC,~,~] = fmincon(f_CC,x0(5:8),[],[],...
        [],[],lb,ub,[],opts);
    x = [x_AC,x_CC];
    res_x(i,:) = x;
    res_err(i) = max(fval_AC,fval_CC);
end

[~,min_err_ix] = min(res_err(res_err>0));
R.bestfit = res_x(min_err_ix,:);
R.res_err = res_err;
R.StartingPoint = StartingPoint;
% 
%% check errors
R.Errors = GetErrors(R.bestfit,dL,dC);

end