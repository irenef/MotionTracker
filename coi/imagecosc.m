function imagecosc(coi, ch)
% imagecosc  display an me image in pseudocolor 
%
% imagecosc(coi, ch) 
% 
% coi - coimage (or coPyramid or matlab image) 
  
  if(iscell(coi)) %allow me pyramids too - we then show level 0
    coi=coi{1};
  end
  
  if(isstruct(coi))
    im = coi.im;
  else % we wern't given an me image... make one
    im = coi;
    coi = coimage(im, [0 0]);
  end
  
  if(nargin>1 && ~isempty(ch))
    coi.im = coi.im(:,:,ch);
  end

  if(isa(im, 'uint8'))
    coi.im = im2double(coi.im);
  end
  if(isempty(coi.im))
    image([]);
  else
    
    
    X = (1:size(im,2))-coi.origin(1);
    Y = (1:size(im,1))-coi.origin(2);
    cla;
    if(size(coi.im,3)==1)
      %c=colormap;
      %image(X,Y,size(c,1)*bound(coi.im, [0 1]));
      imagesc(X,Y,coi.im);
    else
      mr = range(coi.im(:));
      coi.im = (coi.im-mr(:,1))./(mr(:,2)-mr(:,1)+eps);
      if(size(coi.im,3)==2)
        coi.im(:,:,3)=0;
      end
      image(X,Y,bound(coi.im(:,:,1:3), [0 1]));
    end
    axis image;
  end
  title(coi.label, 'Interpreter', 'none');
