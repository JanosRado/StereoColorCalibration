function [ sp ] = InitializesStartingPoint( dL, dC )
% InitializesStartingPoint.m This function initializes the starting point
% of the nonlinear optimization performed by the fmincon function.
% 
% INPUT dL, dC, fitting: as described for NumConstrSolver.
% 
% OUTPUT sp: starting point of the optimization as described for
% NumConstrSolver.

% initialization of StartingPoint
LumMin = dL*(1-dC);
LumMax = dL*(1+dC);

x = linspace(0,255,256);

p_RA = feval(@EvalRA,x);
p_GA = feval(@EvalGA,x);

f = find(p_RA<LumMin,1,'last');
if isempty(f)
StartingPoint(1,[2 4]) =20;
else
StartingPoint(1,[2 4]) =f; 
end
f = find(p_RA<LumMax,1,'last');
if isempty(f)
StartingPoint(1,[1 3]) =240; 
else
StartingPoint(1,[1 3]) =f; 
end

f = find(p_GA<LumMin,1,'last'); 
if isempty(f)
StartingPoint(1,[5 6]) =20; 
else
StartingPoint(1,[5 6]) =f; 
end

f = find(p_GA<LumMax,1,'last'); 
if isempty(f)
StartingPoint(1,[7 8]) =240; 
else
StartingPoint(1,[7 8]) =f; 
end

StartingPoint(StartingPoint<20)=20;

sp=StartingPoint;

end

