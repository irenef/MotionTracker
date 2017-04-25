function c = dtimes(a,b)
% dtimes  array multiply similar to .*, but handles some non-equal matrix sizes
%
% c = dtimes(a,b)

  c=bsxfun(@times, a,b);