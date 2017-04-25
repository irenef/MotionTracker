function rect = points2rect(point1, point2)
% points2rect  make rect from 2 opposite corner points
%
% rect = points2rect(point1, point2)
%
% point1,2 - 1x2 or nx2 as [x y] coord
% rect     - nx4 rectangle that has the corresponding points at
%            opposite corners as [l r b t];
  
  rect = [min(point1(:,1), point2(:,1)) ...
	  max(point1(:,1), point2(:,1)) ...
	  min(point1(:,2), point2(:,2)) ...
	  max(point1(:,2), point2(:,2))];
  
  