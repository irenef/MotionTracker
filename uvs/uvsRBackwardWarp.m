function wr = uvsRBackwardWarp(mot, r)
% uvsRBackwardWarp  warp a rect or set of rects s according to inverse of mot
%
% wc = uvsRBackwardWarp(mot, r)
% i.e. uvsRBackwardWarp(mot, uvsRWarp(mot, r))==r
  
  if(size(r,1)~=size(mot,1))
    if(size(r,1)==1)
      r = repmat(r, [size(mot,1) 1]);
    else
      mot = repmat(mot, [size(r,1) 1]);
    end
  end
  T=[1 1];
  wr(:,1:2) = (r(:,1:2)-mot(:,1*T)+mot(:,4*T).*mot(:,3*T))./(1+mot(:,3*T));
  wr(:,3:4) = (r(:,3:4)-mot(:,2*T)+mot(:,5*T).*mot(:,3*T))./(1+mot(:,3*T));