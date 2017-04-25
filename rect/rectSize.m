function s = rectSize(rect)
% rectSize   size of the rect
%
% s = rectSize(rect)
% rect can have multiple rows, i.e. (:,[l r b t])
% s = [w h];
%
% remark: returns 1 less than the real size for int rects. For those, use
% rectSizeInt() instead.

  s = [rect(:,2)-rect(:,1) rect(:,4)-rect(:,3)];
  