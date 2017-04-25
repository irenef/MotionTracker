function [coidx, coidy] = coiGradient(coi, varargin)
% coiGradient   compute dx and dy derivatives of coimage, opt: blur, apply nonlinearity
%
%
% [coidx,coidy] = coiGradient(coi, params...)
% or 
% [coidxy] = coiGradient(coi, params...)
% parameters used:
%
% dfilter - apply this filter to compute dx derivative
%               transpose to compute dy (def. [-1 0 1]/2)
%               other resonable choices might be:
%                   [ -1 0 1; -2 0 2; -1 0 1]/8;
%                 or more generally:
%                   f = gaussian([-3:3], 0, 2)'*gaussDeriv([-2:2], 0, 1, 1);
%                   f = f./sum(abs(f(:)));
%                 with appropriate extent and sigmas
%            note: this need not be a 1st derivative filter... 
%
% signflag - what to do with the signed channels?
%             0 - nothing
%             1 - abs
%             2 - half wave rectify (see halfWaveRectChannels)
%             3 - normalize to [0 1] from [-1 1]
%             func_handle - give any non-linearity you want as a function
%                  [dxyout, cho] = yourfunc(dxyin, cho);
%
% postblur - blur dx/dy image after abs/halfwave 
%            with this kernel.  Again the kernel is transposed for dy.
%
% shape - 'same' or 'valid', similar to conv2
%
% this function sets an additional field in the image:
% cho - channel orientation +-1=dx, +-2=dy; 
%       if input is 1 channel, and signflag~=2, then: [1 2]
%          with signflag==2:  [1 2 -1 -2]
%
% coidxy is smaller than original such that only the valid region is kept
% after filtering. 
  
  
  params = struct('dfilter', [-1 0 1]/2, 'signflag', [], ...
		      'postblur', [], 'shape', 'valid');
  params = vl_argparse(params, varargin);
  
  matlab_im=0;
  if(isnumeric(coi))
    matlab_im=1;
    coi = meImage(coi, [0 0]);
  end

  if(ischar(params.dfilter) && strcmp(params.dfilter, 'sobel'))
    params.dfilter = [ -1 0 1; -2 0 2; -1 0 1]/8;
  end
  sz = size(coi.im);
  b = max(floor(size(params.dfilter)/2));
  %check size
  if(any(sz(1:2)-(2*b)<=0))  
    %size of image too small, just fake it
    dxy = zeros(0, 0, size(coi.im,3)*4);
    cho = [1 2 -1 -2];
    orig_off = 0;
  else    
    for i=1:size(coi.im,3)
      % compute derivatives for all channels
      dx(:,:,i) = filter2(params.dfilter, coi.im(:,:,i), 'same');
      dy(:,:,i) = filter2(params.dfilter', coi.im(:,:,i), 'same');
    end % for i=1:size(coi.im,3)
       
    if(strcmp(params.shape, 'valid'))
      dx = dx(1+b:end-b,1+b:end-b,:);
      dy = dy(1+b:end-b,1+b:end-b,:);
      orig_off= b;
    else
      dx = zeroImBorder(dx, b);
      dy = zeroImBorder(dy, b);
      orig_off = 0;
    end
    

    % abs or half wave rectify
    dxy = cat(3, dx, dy); cho=[ones(1,size(dx,3)) ones(1,size(dx,3))*2];
    if(length(params.signflag))
      if(isnumeric(params.signflag))
        if(params.signflag==1)
          dxy = abs(dxy);
        elseif(params.signflag==2)
          dxy = halfWaveRectChannels(dxy);
          cho = [cho -cho];
        elseif(params.signflag==3)
          dxy = (dxy*0.5+0.5);
        end
      elseif(isa(params.signflag, 'function_handle'))
        [dxy,cho] = feval(params.signflag, dxy, ch);
      end
    end
    
    if(length(params.postblur)>1)
      for i=find(abs(cho)==1)
	dxy(:,:,i) = filter2(params.postblur, dxy(:,:,i), 'same'); 
      end
      for i=find(abs(cho)==2)
	dxy(:,:,i) = filter2(params.postblur',dxy(:,:,i), 'same'); 
      end
    end
    
  end
  
  %make the image
  coidxy = coimage(dxy, coi.origin-orig_off, [coi.label '_dxy'], coi);
  coidxy.cho = cho;
  
  coidx=coidxy;
  if(nargout==2)
    % we were aksed to return a seperate dx and dy image...
    coidy = coidx;
    coidx.im = coidx.im(:,:,abs(cho)==1);
    coidx.cho = cho(abs(cho)==1);
    coidy.im = coidy.im(:,:,abs(cho)==2);
    coidy.cho = cho(abs(cho)==2);
  end
  
  % convert back to matlab image if that is what was asked of us
  if(matlab_im)
    coidx = coidx.im;
    if(nargout==2)
      coidy = coidy.im;
    end
  end
  
function hwim = halfWaveRectChannels(im)
% halfWaveRectChannels   given an image, split the channels into positive and negative components
%
% hwim = halfWaveRectChannels(im)
%
% hwim - has 2N channels, where im had N, but all are positive valued
%        the first N are non zero where im was >0, 
%        the 2nd   N are non zero where im was <0
  
  hwim = cat(3, im.*(im>0), -im.*(im<0)); 

function im = zeroImBorder(im, n, v)
% zero (or copy some fixed value v into) the border of an image...
% im = zeroImBorder(im, n, v)
% n: (opt) number of pixels (can be 2 numbers [x y]) (def 5)
% v: (opt) value to write (def 0)
  
  
  if(nargin<2)
    n=5;
  end
  
  if(nargin<3)
    v=0;
  end
  
  im(1:n(end),:,:)=v;
  im(end-(0:(n(end)-1)),:,:)=v;
  im(:,1:n(1),:)=v;
  im(:,end-(0:(n(1)-1)),:)=v;
