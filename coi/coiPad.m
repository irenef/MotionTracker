function pcoi = coiPad(coi, rect, padvalue)
% coiPad   pad an ME image to include a rectangular region 
%
% pcoi = coiPad(coi, rect, padvalue)
%
% rect - the rect is first rounded (see rect2int)
% padvalue - (o) may be a number or any other "METHOD" paramter to matlab's padarray
%  (e.g. 'replicate') (def. 0)
%
% This function is useful together with coiCut, which returns a smaller than
% requested image when the rectangle falls outside of the original image.
%
% example:
%  coi = coimage(rand(5), [2 2]);
%  figure; imageco(coi); 
%  ccoi = coiCut(coi, int2rect([-3 2 0 5]));
%  figure; imageco(coiPad(ccoi, int2rect([-3 2 0 5]), 'replicate'));
  
  if(nargin<3)
    padvalue=0;
  end


  if(~isfield(coi, 'nopadrect'))
    nopadrect= coiImageRect(coi);
  else
    nopadrect = rectIntersect(coiImageRect(coi), coi.nopadrect);
  end
  
  % a little shortcut: check to see if the rect is already 
  %   completely inside the image
  coirect = coiImageRect(coi);
  if(all([rect([1 3])>=coirect([1 3]) rect([2 4])<=coirect([2 4])]))
    pcoi = coi; 
    pcoi.nopadrect = nopadrect;    
    return; % if so, nothing needs to be done
  end
  
  imrect = rect2int(coi2imcoord(coi, rect));
  
  newim = coiBlank(rectUnion(rect, coirect));
  if(length(padvalue)==1)
      newim.im(:) = padvalue;
  end
  if(size(coi.im,3)>1)
    newim.im = repmat(newim.im, [1 1 size(coi.im,3)]);
  end
  newim = coiCopyInto(newim, coi);    
  origin = coi.origin+max(0,1-imrect([1 3]));
  
  pcoi = coimage(newim.im, origin, [coi.label, '_p'], coi);
  pcoi.nopadrect = nopadrect;
  
  if(length(padvalue)>1 && ischar(padvalue))
    newrect = coiImageRect(pcoi);
    switch(padvalue)
      case 'replicate'
        pcoi.im(1:coirect(3)-newrect(3),coirect(1)-newrect(1)+(1:diff(coirect(1:2))),:) = ...
          repmat(coi.im(1,:,:), [coirect(3)-newrect(3) 1 1]);
        pcoi.im(end+1-(1:newrect(4)-coirect(4)),coirect(1)-newrect(1)+(1:diff(coirect(1:2))),:) = ...
          repmat(coi.im(end,:,:), [newrect(4)-coirect(4) 1 1]);
        pcoi.im(:, 1:coirect(1)-newrect(1),:) = ...
          repmat(pcoi.im(:,coirect(1)-newrect(1)+1,:), [1 coirect(1)-newrect(1) 1]);
        pcoi.im(:,end+1-(1:newrect(2)-coirect(2)),:) = ...
          repmat(pcoi.im(:,end-(newrect(2)-coirect(2)),:), [1 newrect(2)-coirect(2) 1]);
      case 'mirror'
        pcoi.im(1:coirect(3)-newrect(3),coirect(1)-newrect(1)+(1:diff(coirect(1:2))),:) = ...
          coi.im(coirect(3)-newrect(3):-1:1,:,:);
        pcoi.im(end+1-(1:newrect(4)-coirect(4)),coirect(1)-newrect(1)+(1:diff(coirect(1:2))),:) = ...
          coi.im(end+1-(newrect(4)-coirect(4):-1:1),:,:);
        d = coirect(1)-newrect(1);
        pcoi.im(:, 1:d,:) = pcoi.im(:,2*d:-1:d+1,:);
        d = newrect(2)-coirect(2);
        pcoi.im(:,end+1-(1:d),:) = pcoi.im(:,end+1-(2*d:-1:d+1),:);
      otherwise
        error('Unknown pad type: %s', padvalue);
    end
  end