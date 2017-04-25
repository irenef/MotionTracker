function coi = coimage(im, origin, label, level, cpcoi)
% coimage   make a  coordiante mage from a matlab image matrix
%
% coi = coimage(im, origin, label, level, cpcoi)
%
% im - matlab image matrix
% origin - location of the image origin in im coordiantes 
%     (note: im coordinates are matlab coord, which means the 
%      lower left corner is <x,y>=[1,1])
%
% optional arguments (as allways, all optional arguments can be not 
% specified by giving [] as the argument) :
% 
% label - (o) a string to identify the image (e.g. filename, etc.) (def. 'image')
% level - (o) level number (def. inf == unknown)
% cpcoi - (o) an coi to copy any of the unspecified fields from 
% 
% Any of the optional arguments above (label ... meta) may be a cpcoi 
% instead of the above described argument.  If such a cpcoi is given 
% anywhere, then all unspecified fields will be copied from cpcoi.  To make
% it easy to add aditional fields to coi that will automatically be carried
% around to all modifications of the coi (e.g. reduce, cut, etc.), you 
% should always include cpcoi whenever possible. 
%
% coi - a struct that looks something like this:
%            im: [480x640 double]
%        origin: [307 271]
%         label: 'data019_00010_L0'
%         level: 0
%
%
% Example:  the function coiReduce which changes label & level but not 
% timestamp or meta fields would call coimage to create the reduced
% image like this:
%
% new_coi = coimage(new_im, new_orgin, new_label, in_level+1, in_coi);
  
  %the image
  if(isstruct(im))
    coi = im;
    coi1 = im;
  else
    coi.im = im;
    coi1=[];
  end
  
  % for each argument (origin ... meta) see if it was given or if a 
  % cpcoi image was given instead from which to copy all missing
  % fields ...
  if(nargin>1 && ~isempty(origin))
    if(isstruct(origin) && isfield(origin, 'im'))
      coi1 = origin;
      coi.origin= coi1.origin;
    else
      coi.origin = origin;
    end
  else
    coi.origin = [];
  end
  
  
  if(nargin>2 && ~isempty(label))
    if(isstruct(label) && isfield(label, 'im'))
      coi1 = label;
      coi.label='image';
    else
      coi.label = label;
    end
  else
    coi.label = 'image';
  end
  
  if(nargin>3 && ~isempty(level))
    if(isstruct(level) & isfield(level, 'im'))
      coi1 = level;
      coi.level=inf;
    else
      coi.level=level;
    end
  else
    coi.level=inf;
  end
  
  if(nargin>4 && ~isempty(cpcoi))
    coi1=cpcoi;
  end
  
  % if we were given a cpcoi in any argument above, copy the 
  % fields that were set to the default values
  if(isstruct(coi1))
    if(length(coi.origin)<2)
      coi.origin=coi1.origin;
    end
    if(strcmp(coi.label,'image'))
      coi.label=coi1.label;
    end
    if(isinf(coi.level))
      coi.level=coi1.level;
    end
  end

  if(length(coi.origin)<2)
    coi.origin=[0 0];
  end
