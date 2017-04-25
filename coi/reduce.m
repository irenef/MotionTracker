function outim = reduce(im, filt, offset)
% reduce   blur and subsample by a factor of 2
%
%  outim = reduce(im, filt, offset) 
%
%  im       input image
%  filt     (o) filter to use for blurring (def [1 4 6 4 1]) ([] to use def)
%  offset   (o) offset for subsampling in [x y] i.e. subsamp=(x:2:end) (def [2 2])
  
  if(nargin<2 | length(filt)==0)
    tim = blur(im);
  else
    tim = blur(im, filt);
  end
  
  if(nargin<3)
    offset = [2 2];
  end
  outim = tim(offset(2):2:end,offset(1):2:end,:);
