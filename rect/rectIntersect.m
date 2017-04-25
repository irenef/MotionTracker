function rect = rectIntersect(rect1, rect2)
% rectIntersect  intersect 2 rects 
%
% rect = rectIntersect(rect1, rect2)
% where each rect{1,2} may be either 1x4 or nx4. Result is nx4. 
% or 
% rect = rectIntersect(rects)
% where rects = [nx4] matrix of rectangles. Result is 1x4.

if(nargin==1)
    rect(:,[1 3]) = max(rect1(:,[1 3]));
    rect(:,[2 4]) = min(rect1(:,[2 4]));
  else
    rect(:,[1 3]) = dmax(rect1(:,[1 3]),rect2(:,[1 3]));
    rect(:,[2 4]) = dmin(rect1(:,[2 4]),rect2(:,[2 4]));
  end  
  rect(rect(:,1)>rect(:,2), [1 2])=0;
  rect(rect(:,3)>rect(:,4), [3 4])=0;
  