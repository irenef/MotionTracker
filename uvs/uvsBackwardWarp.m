function wcoi = uvsBackwardWarp(mot, mei, destrect)
% uvsBackwardWarp  warp the image using mot's inverse and cut the result to destrect 
%
% wcoi = uvsBackwardWarp(mot, mei, destrect)
% 
% if mot is the motion from A -> B, then this function warps a piece of B (input coi)
% (aka. source) to be aligned with A (aka. dest). The pixels that should exist
% in the result is defined by rounding destrect, which is in A's coordinate system. 
%
% This function just calls:
%   wcoi = uvsWarp(uvsInv(mot), mei, destrect);
  
  wcoi = uvsWarp(uvsInv(mot), mei, destrect);
  