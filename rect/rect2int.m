function irect = rect2int(rect, offset,force)
% rect2int  round the coordinates of the rect for addressing pixels 
%
% irect = rect2int(rect, offset)
%
% offset - (o) offset of each pixel from the grid [x y] (def. [0 0])
%              only the non-integer component of x,y are used, so 
%              just pass in mei.origin when that is non-integer.  
%
% force - (o) force conversion (even when rect already looks like it is int).
%
% "integer" rects are rects where the rect edge falls on the center of each pixel 
% (not the edge of each pixel, as the standard rect does). Thus 
% rectSize(irect) is actually 1 smaller than the actual size of the rect.  
% irect is typically used to iterate over or cut out the actual pixels 
% (i.e. irect(1):irect(2)).
%
% This function rounds to the actual pixels that make up the rectangle. A pixels has
% to be at least 50% inside the rect in order to make it (this may not be strictly
% true for the corners...).
%
% This does:  irect = roundto(rect+[0.5 -0.5 0.5 -0.5], offset([1 1 end end]));
%
% Note: this means that if offset is non-integer, the resulting irect also 
% won't have integer values - but mei2imcoord(mei, irect) will allways be integer...
%
% Special Case: if the input rect is already an integer rect, it is not touched. 
%
  
  if(nargin<2 || isempty(offset))
    offset=[0 0];
  end
  
  if((nargin<3 || ~any(force)) && all(round(rect(:))==rect(:)))
    irect=rect;
    return;
  end
  
  irect = roundto(dplus(rect,[0.5 -0.5 0.5 -0.5]), offset([1 1 end end]));
  
  