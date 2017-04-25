function wrect = uvsRWarp(motion, rect)
% uvsRWarp   warp a rect or set of rects according to mot
%
% wr = uvsRWarp(mot, r)
%
% motion - n-by-5 array of motions
% rect - m-by-k array of rects (k is atleast 4).
%
% remark: the function works correctly in the following scenarios:
% a. the same number of motion and rects - each motion will be applied to the corresponding rect
% b. multiple motions, one rect: all motions will be applied to the same rect
% c. multiple rects, one motion: the same motion will be applied to all
%    rects 

assert( ( size(motion,1) == size(rect,1) ) || ( size(motion,1) == 1 ) || ( size(rect, 1) == 1 ) );

left = rect(:,1);  right = rect(:,2); 
bottom = rect(:,3); top = rect(:,4);
u = motion(:,1); v = motion(:,2); s = motion(:,3);
x0 = motion(:,4); y0 = motion(:,5);

wl = left   + u + s.*(left   - x0);
wr = right  + u + s.*(right  - x0);
wb = bottom + v + s.*(bottom - y0);
wt = top    + v + s.*(top    - y0);
wrect = [wl wr wb wt];

%  wr(:,1:2) = dplus(r(:,1:2), dplus(mot(:,1), dtimes(mot(:,3), dminus(r(:,1:2),mot(:,4)))));
%  wr(:,3:4) = dplus(r(:,3:4), dplus(mot(:,2), dtimes(mot(:,3), dminus(r(:,3:4),mot(:,5)))));
  
  
