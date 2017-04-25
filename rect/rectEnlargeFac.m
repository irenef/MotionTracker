function rect = rectEnlargeFac(rect, fac, margin)
% rectEnlargeFac  change the rectangle rect by enlarging the rect by mult factor
%
% rect = rectEnlargeFac(rect, fac)
%
% fac is fraction of width/2 or hight/2 
% fac may be 1x1 (all sides), 1x2 (horiz, vert), or 1x4 in length
% positive means enlarge,  negative means shrink ([] means do nothing)
% 
% e.g. rectEnlargeFac(rect, -1) shrinks it to a point
%      rectEnlargeFac(rect, [0 1]) doubles the in the horiz direction    
%
% if optional argument margin given, then call 
% rect = rectEnlargeFac(rect, margin)
% after rect has been enlarged by fac. 
% 
% see also rectEnlarge (the difference beteween the 2 is the order)
 
  w = diff(rect(:,1:2),1,2);
  h = diff(rect(:,3:4),1,2);
  
  switch size(fac,2)
   case 0
    margin1 = [0 0 0 0];
    % do nothing 
   case {1,4}
    margin1 = dtimes(fac,[w w h h]/2);
   case 2
    margin1 = dtimes(fac(:,[1 1 2 2]),[w w h h]/2);
   otherwise
    error('fac must be n-by-{1, 2, or 4} in length');
  end
  rect = rectEnlarge(rect, margin1);
  if(nargin==3)
    rect = rectEnlarge(rect, margin);
  end
