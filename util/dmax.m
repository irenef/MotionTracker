function c = dmax(a,b)
% dmax  array max similar to max, but handles some non-equal matrix sizes
%
% c = dmax(a,b)

  c=bsxfun(@max, a,b);