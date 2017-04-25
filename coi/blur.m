function outim = blur(im, filt)
%  outim = blur(im, filt) 
%  im       input image
%  filt     (opt, default=[1 4 6 4 1]) filter to use for blurring
%           filt may also be a sigma value, where the filter is a gaussian with 
%           that sigma. 
  
  if(nargin<2 || isempty(filt))
    filt = [1 4 6 4 1];
  else
    if(length(filt)<3) % create a gaussian filter with given sigma  
      f = cell(1, length(filt));
      for i=1:length(filt)
        x = floor(-2.5*filt(i)):ceil(2.5*filt(i));
        f{i} = gauss_pdf(x, 0, filt(i).^2);
      end
      filt = f{1}'*f{end};
    end
  end
  if(size(filt,1)==1)
    filt = filt'*filt;
  end

  filt = filt/sum(sum(filt));
  outim = zeros(size(im));
  for i=1:size(im,3)
    outim(:,:,i) = conv2(double(im(:,:,i)),filt,'same');
  end

  
