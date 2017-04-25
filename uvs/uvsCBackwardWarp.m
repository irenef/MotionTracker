function wc = uvsCBackwardWarp(mot, c);
% uvsCBackwardWarp   warp a point or set of points s according to inverse of mot
%
% wc = uvsCBackwardWarp(mot, c)
% i.e. uvsCBackwardWarp(mot, uvsCWarp(mot, c))==c
  
  wc(:,1) = (c(:,1)-mot(1)+mot(4)*mot(3))./(1+mot(3));
  wc(:,2) = (c(:,2)-mot(2)+mot(5)*mot(3))./(1+mot(3));
