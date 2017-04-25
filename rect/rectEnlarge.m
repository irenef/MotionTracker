function rectout = rectEnlarge(rect, margin, fac)
% rectEnlarge  change the rectangle rect by adding a margin to it
%
% rect = rectEnlarge(rect, margin, fac)
%
% margin may be 1x1 (all sides), 1x2 (horiz, vert), or 1x4 in length
% positive means enlarge,  negative means shrink ([] means do nothing)
%
% if optional argument fac given, then call 
% rect = rectEnlargeFac(rect, fac)
% after margin has been added to rect.
%
% see also rectEnlargeFac (the difference beteween the 2 is the order)
  
  switch size(margin,2)
   case 0
    % do nothing
   case 1
    rectout = dplus(rect(:,1:4),[-margin margin -margin margin]);
   case 2
    rectout = dplus(rect(:,1:4), [-margin(:,1) margin(:,1) -margin(:,2) margin(:,2)]);
   case 4
    rectout = dplus(rect(:,1:4),[-margin(:,1) margin(:,2) -margin(:,3) margin(:,4)]);
   otherwise
    error('margin must be 1x1 (all sides), 1x2 (horiz, vert), or 1x4 in length');
  end
  rectout(:,5:size(rect,2))=rect(:,5:end);
  if(nargin==3)
    rectout = rectEnlargeFac(rectout, fac);
  end
