function wcoi = uvsWarp(mot, coi, destrect, crop_it)
% uvsWarp  warp the image using mot and cut the result to destrect 
%
% wcoi = uvsWarp(mot, coi, destrect)
% 
% if mot is the motion from A -> B, then this function warps a piece of A
% (input coi) (aka. source) to be aligned with B (aka. dest). The pixels that
% should exist in the result is defined by rounding destrect, which is in B's
% coordinate system.
%
% destrect - (o) me rect, and is rounded by rect2int to find the pixels that
% will exist in the final image.  Note: this means that an "integer" sized and
% pixel aligned rectangle typically looks like [-1.5 1.5 -2.5 2.5], not [-1 1
% -2 2]. If not given, the whole input image is warped and the resulting
% image will be assumed to be integer aligned.
%
% crop_it - (o) default: true; if true and if destrect is too large for 
% warped image, the 2 are intersected - similar to coiCut (Note: it's pixel offset is still used for the final image
% pixel offset. Also if true, any nan rows/columns are removed (due to
% input image)
  
  
  if(~exist('crop_it', 'var'))
    crop_it = true;
  end 
  crect = coiImageRect(coi);
  if(nargin<3)
    destrect = uvsRWarp(mot, rectEnlarge(coiImageRect(coi), -1));
  end
  idestrect = rect2int(destrect);
  if(crop_it)
    %make sure destrect is not too large, if so, cut it down
    wirect = uvsRWarp(mot, rectEnlarge(crect,-0.99));
    if(nargin<3 || length(destrect)<4)
      destrect = wirect;
      doffset = [0 0];
    else
      % make sure we were given an integer sized rect
      assert(all(mod(rectSize(destrect),1)==0), ...
        'uvsWarp: Destrect must be an integer sized rect (e.g. returned by coiImageRect()).');
      % the offset of the pixels in dest image
      doffset = mod(destrect([1 3])+0.5,1);
    end
    destrect = rect2int(rectIntersect(wirect, destrect));
    idestrect = rect2int(destrect, doffset);
  end 
  
  if(any(rectSize(destrect)<1))
    wim = zeros(0,0,size(coi.im,3));
  else
    %use my function
    % compute where idestrect must come from ...
    srect = uvsRBackwardWarp(mot, idestrect);
    % now warp between the rectangles
    wim = resampleMei(coi, srect, idestrect);
  end
  if(crop_it && (isnan(wim(1,1)) || isnan(wim(end,end)))) %remove any additional nans
    imgood = ~isnan(wim);
    xi = any(imgood,1);
    yi = any(imgood,2);
    wim = wim(yi,xi);
    idestrect([1 3]) = idestrect([1 3])+[find(xi,1) find(yi,1)]-1;
    idestrect([4 2]) = idestrect([3 1])+size(wim)-1;
  end
  
  wcoi = coimage(wim, 1-idestrect([1 3]), [coi.label '_warp'], coi);
  
function rim = resampleMei(coi, srect, drect)
%
%
%
  
  % the rect in the matlab image
  isrect = coi2imcoord(coi, srect);
  % the integer rect to be cut in matlab image coords
  crect = [floor(isrect(1)) ceil(isrect(2)) floor(isrect(3)) ceil(isrect(4))];
  % the cut matrix where (1,1) is the lowest pix that will need to be sampled
  cutim = coi.im(crect(3):crect(4),crect(1):crect(2),:);
  % srect in the new cut image (isrect(1)>=crect(1)) 
  cisrect = isrect-[crect(1) crect(1) crect(3) crect(3)]+1;
  
  %now resample
  s = rectSize(drect)+1; % drect is an integer rect, so size is 1+rectSize.
  rim = resample1D(cutim, cisrect(3:4),  s(2), 1);
  rim = resample1D(rim, cisrect(1:2),  s(1), 2);
  
function B = resample1D(Ain, source, dests, dim)
%
%
% 
% source - [sl sr] coordnates of a along dim (may be float)
% dest   - dr (integer) where range will be [1 dr]
% dim  - dimention to resample along

A=double(Ain);
  rr = linspace(source(1),source(2),dests);
  lp = floor(rr); 
  rp = ceil(rr); 
  rw = mod(rr,1);
  lw = 1-rw;
  
  if(dim==1)
    B = dtimes(A(lp,:,:),lw')+dtimes(A(rp,:,:),rw');
  elseif(dim==2)
    B = dtimes(A(:,lp,:),lw) +dtimes(A(:,rp,:),rw);
  end
  
  
  