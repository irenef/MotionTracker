function secondMot = uvsMinus(totalMot, firstMot)
% uvsMinus   totalMot-firstMot (center is computed from firstMot's center)
%
% secondMot = uvsMinus(totalMot, firstMot)
% 
% the resulting secondMot should have the property that firstMot+secondMot = totalMot
% thus totalMot's and firstMot's center must be at the same spot
% secondMot's center is at firstMot's center warped by firstMot
%
% remark: this function can work in the following modes:
% 1. If both totalMot and firstMot contain the same number of rows, then each
%    pair of corresponding rows will be handled separately. 
% 2. if either of the two inputs has one row, then this value will be
%    used for subtraction with each of the rows of the other input,
%    separately. 
  
% enum
U = 1;
V = 2;
S = 3;
X0 = 4;
Y0 = 5;

assert(max(max(abs(totalMot(:,X0:Y0)-firstMot(:,X0:Y0))))<0.001, 'Centers dont agree.');

secondMot = zeros(max(size(totalMot,1), size(firstMot,1)),5);
secondMot(:,U:V) = totalMot(:,U:V)-firstMot(:,U:V);
secondMot(:,S) = ((1+totalMot(:,S))./(1 + firstMot(:,S)))-1;
secondMot(:,X0:Y0) = firstMot(:,X0:Y0)+firstMot(:,U:V);
