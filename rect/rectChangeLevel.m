function nrect = rectChangeLevel(rect, oldlev, newlev)
% rectChangeLevel   change the pyramid level of the rect 
%
% nrect = rectChangeLevel(rect, oldlev, newlev)
% 
  
  factor = 2^(oldlev-newlev);
  if(size(rect,2)>4)
    nrect=rect;
    nrect(:,1:4)=rect(:,1:4).*factor;
  else
    nrect=rect.*factor;
  end