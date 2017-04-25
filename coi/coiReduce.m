function coi = coiReduce(coi, varargin)
% coiReduce   blur and subsample image by factor of 2
% 
% coi = coiReduce(coi, params...)
% 
% coi - me image (see coimage)
% 
% used params:
%   'reduce_filt' - filter to use for blurring (e.g. [1 2 1]). The filter
%                   will be normalized and used in both directions (x&y).  
  
  params.reduce_filt = [1 2 1];
  params = vl_argparse(params, varargin);
  
  
  baselabel = coi.label;
  if(all(baselabel(end-2:end-1)=='_L'))
    baselabel=baselabel(1:end-3);
  end
  label = [baselabel '_L' num2str(coi.level+1)];
  
  offset = (~mod(coi.origin,2))+1;
  %now blur and subsample by factor of 2 such that the origin is sampled

  ssim = reduce(coi.im, params.reduce_filt, offset);
  coi = coimage(ssim, ceil(coi.origin/2), label, coi.level+1, coi);  
  coi.meta(1).reduceOffset = offset;
  
  
