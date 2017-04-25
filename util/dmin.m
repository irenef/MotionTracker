function c = dmin(a,b)
% dmin  array max similar to max, but handles some non-equal matrix sizes
%
% c = dmin(a,b)

  c=bsxfun(@min, a,b);