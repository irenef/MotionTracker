function a_out = bound(a, lims)
% bound   cap the values of b to the range lims 
%
% a_out = bound(a, lims)
%
% equal to
%  a_out = max(lims(:,1), min(lims(:,2), a));
  
  a_out = max(lims(:,1), min(lims(:,2), a));