function imageco(coi, dynamic_range, lev, Y)
% imageco  displays an coimage in grayscale   
%
% imageco(coi, dynamic_range, lev) 
% or
% imageco(coi, dynamic_range, X,Y) 
% 
% coi - coimage (or mePyramid or matlab image) 
% dynamic_range - controls image normalization:
%                 if scalar, gives threshold of (max-min) 
%                    for automatically normlizing
%                 if [min max] range, normalizes image pixel values 
%                    in this range to [0 1]  
% lev - if given, scale coordinates to this level
%
% e.g. imageco(coi, 1)  % normalize everything to [0 1] range
    
  if(iscell(coi)) %allow me pyramids too - we then show base level
    coi=coi{1};
  end
  
  if(nargin<2 || isempty(dynamic_range))
    dynamic_range = 0.01;
  end

  if(isstruct(coi))
    im = coi.im;
  else % we wern't given an me image... make one
    im = coi;
    clear coi; 
    coi = coimage(im, [0 0]);
  end
  
  if(isa(im, 'uint8'))
    im = im2double(im);
  end

  if(any(size(im)==0))
    image(0); return;
  end
  
  if(size(im,3)==3)
    im3 = (im/max(1.0, max(im(:))));
  else
    if(size(im,3)>1) % if number of channels is not 1 (or 3 above)
      im=im(:,:,1); %use only the 1st channel
    end
    mr = [min(im(:)) max(im(:))];
    if(length(dynamic_range)==1)
      if(mr(1)<0 | (mr(2)-mr(1))<dynamic_range) 
	% if min(im) is negative, or im has a small dynamic range, 
	% normalize to [0 1]
	im3 = repmat((im-mr(1))./(mr(2)-mr(1)+eps),  [1 1 3]);
      else % no need to normalize
	im3 = (repmat(im(:,:,1), [1 1 3])/max(1.0, max(max(im(:,:,1)))));
      end
    elseif(length(dynamic_range)==2)
      %dynamic_range range was given, normalize to it
      im3 = min(1, max(0, repmat((im-dynamic_range(1))./ ...
				 (diff(dynamic_range)+eps),  [1 1 3])));      
    end
  end

  
  cla reset;
  axisimage=true;
  if(nargin>3) % X,Y give as input
    X = lev;
    % Y given as input
    axisimage=false;
  elseif(isfield(coi, 'meta') && isfield(coi.meta, 'Xcoord') && isfield(coi.meta, 'Zcoord'))
    X = coi.meta.Xcoord;
    Y = coi.meta.Zcoord;
    axisimage=false;
  else
    X = (1:size(im3,2))-coi.origin(1);
    Y = (1:size(im3,1))-coi.origin(2);
    if(nargin>=3 && ~isempty(lev) && ~isinf(lev) && ...
       ~isinf(coi.level) && coi.level~=lev)
      factor = 2^(coi.level-lev);
      X = X*factor;
      Y = Y*factor;
      coi.label = [coi.label '_showL', num2str(lev)];
    end
  end
  image(X,Y,im3);
  if(axisimage)
    axis image;
  end
  axis manual;
  if(isfield(coi, 'label'))
    title(coi.label, 'Interpreter', 'none');
  end
