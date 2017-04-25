function cop = coPyramid(coi, levs, varargin)
% coPyramid   make a coordinate pyramid from and coimage with L levels 
% 
% mep = mePyramid(coi, levs)
% 
% coi - coimage or a cell array of co images (see coimage) 
%       If cell array of multiple images, then the images should represent
%       different levels of the same scene.  For example, coi could be a 
%       previously built coPyramid. 
%
% levs - level range to return as [base top] or 
%           just [top] which is equal to [lowest_input top] (def. [4])
%
% cop  - cell array of images where cop{1} is the bottom most level given 
%        (original image)

  if(isstruct(coi))
    coi = {coi};
  end
  
  inlevs = [];
  for i=1:length(coi)
    inlevs = [inlevs coi{i}.level];
  end
  inlevs = sort(inlevs);
  if(nargin<2)
    levs=4;
  end
  if(length(levs)==1)
    levs = [min(inlevs) levs];
  end

  % these are used to build the initial pyramid. Some levels may be killed 
  % later if the range of inlevs is greater then the requested levels
  minlev = min(levs(1), min(inlevs));
  maxlev = max(levs(end), max(inlevs));
  
  % make initial pyramid by placing input image into the pyramd and 
  % reducing them to make higher levels
  cop={};
  for lev = minlev : maxlev
    mlevi = find(inlevs==lev);
    if(length(mlevi))
      cop{end+1} = coi{mlevi(1)};
    elseif(lev>minlev & length(cop))
      cop{end+1} = coiReduce(cop{end}, varargin{:});
    else
      cop{end+1}=[];
    end
  end
    
  %finally remove levels that are out of the 'levs' range
  cop = {cop{(levs(1):levs(2))-minlev+1}}';
  