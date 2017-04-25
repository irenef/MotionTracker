function mot = uvsPlus(mot1, mot2)
% uvsPlus   mot1+mot2 (center stays at mot1's center)
%
% mot = uvsPlus(mot1, mot2)
% or
% mot = uvsPlus(mots)
% where mots is nx5 matrix - in this case the n motions are added order.
%
% Result:
% mot - the aggregate motion that is equal to warping by mot1 then
% by mot2.
%
% When combining motions, mot1's center warped by mot1 must be the location of
% mot2's center.   This function calls uvsChangeCenter in case this
% is not the case.
%
% remark: the function works correctly in the following scenarios:
% a. the same number of motions in mot1 and mot2 - each corresponding pair
%    will be summed separately.
% b. multiple motions in either mot1 or mot2, and a single motion in the 
%    other: the single motion will be added to each of the multiple motions separately.  

% enum
U = 1;
V = 2;
S = 3;
X0 = 4;
Y0 = 5;

if(nargin<2)
  mot = mot1(1,:);
  for i= 2:size(mot1,1)
    mot = uvsPlus(mot, mot1(i,:));
  end
else
  mot2 = uvsChangeCenter(mot2, mot1(:,X0:Y0)+mot1(:,U:V));
  mot = mot1;
  mot(:,U:V) = mot1(:,U:V)+mot2(:,U:V);
  mot(:,S) = (1+mot1(:,S)).*(1 + mot2(:,S))-1;
end