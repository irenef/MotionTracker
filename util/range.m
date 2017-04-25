function [rng] = range(a, dim)
% range   computes the range of the values in a
%
% [rng] = range(a, dim)
% 
% a - numeric vector or matrix;
% dim - (o) optional dim argument to min, max for matrix a's;
%
% rng - [mn mx] where
%       mn = min(a, [], dim);
%       mx = max(a, [], dim);
  
  if(nargin==2)
    mn = min(a, [], dim);
    mx = max(a, [], dim);
  else
    mn = min(a);
    mx = max(a);
  end
  
  rng = [mn mx];