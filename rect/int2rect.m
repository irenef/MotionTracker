function rect = int2rect(irect)
% int2rect  take the integer rect coordinates and make them into normal  
%
% rect = int2rect(irect)
% 
% that is: rect = irect+[-0.5 0.5 -0.5 0.5]
%
% "integer" rects are rects where the rect edge falls on the center of each pixel 
% (not the edge of each pixel, as the standard rect does). Thus 
% rectSize(irect) is actually 1 smaller than the actual size of the rect.  
% irect is typically used to iterate over or cut out the actual pixels 
% (i.e. irect(1):irect(2)).
%
% see also rect2int
  
  rect = dplus(irect, [-0.5 0.5 -0.5 0.5]);
