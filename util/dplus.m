function c = dplus(a,b)
% dplus  array add similar to +, but handles some non-equal matrix sizes
%
% c = dplus(a,b)

  c=bsxfun(@plus, a,b);