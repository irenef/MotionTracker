function ccoi = coiCut(coi, rect, safety_border)
% coiCut   cut a rectangular region from ME image coi 
%
% ccoi = coiCut(coi, rect, safety_border)
%
% The rect is first rounded (according to our rect rules). 
% Use safety_border if you belive the edge of the image might be suspect, and 
% should not be used.  If rect is larger than imageRect-safety_border, the 
% intersection area is returned.
%
% If you need an image exaclty the size of rect, use coiCut and coiPad together.
  
  if(nargin<3 || isempty(safety_border))
    safety_border=0;
  end
  
  rect = rectIntersect(rect, rectEnlarge(coiImageRect(coi), -1*safety_border));
  if(all(rect==coiImageRect(coi)))
    ccoi = coi; % a little shortcut...
    return;
  end
  
  if(prod(rectSize(rect)))
    imrect = rect2int(coi2imcoord(coi, rect));
    origin = 1-im2coicoord(coi, imrect([1 3]));
    
    ccoi = coimage(coi.im(imrect(3):imrect(4),imrect(1):imrect(2),:),...
      origin, [coi.label, '_c'], coi);
  else
    ccoi = coimage(zeros(0,0,size(coi.im,3)), [0 0], [coi.label, '_c'], coi);
  end
  
  if (isfield(coi,'interlaced'))
      ccoi.interlaced = coi.interlaced;
  end
  ccoi.imgRect = coiImageRect(ccoi);
end