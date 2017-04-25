function c = im2coicoord(coi, c)
% im2coicoord   convert image coord or rect c to coi coord/rect 
%
% cout = im2coicoord(coi, cin)
%
% coi - coimage
% cin - matrix where each row is either a coord [x y], a rect [l r b t], 
%       or a single index [ idx ] into the image 
%       (so [y, x] = ind2sub(im, idx))
%
% example: to find the position of the max pixel value of coi, do
% [v, idx] = max(coi.im(:));
% c = im2coicoord(coi, idx);
  
  if(size(c,2)==1)
    [y, x, ~] = ind2sub(size(coi.im), c);
    c = [x y];
  end
  
  if(size(c,2)==2)
    c = [c(:,1)-coi.origin(1) c(:,2)-coi.origin(2)];
  elseif(size(c,2)==4)
    c = [c(:,1)-coi.origin(1) c(:,2)-coi.origin(1) ...
	 c(:,3)-coi.origin(2) c(:,4)-coi.origin(2)];
  end
  