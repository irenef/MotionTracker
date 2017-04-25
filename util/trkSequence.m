function ims = trkSequence(fs, rects, varargin)
% trkSequence   make a 3D sequence matrix by aligning rects from multiple frames
%
% ims = trkSequence(fs, rects, params...)
% 
% fs - FaceSequence class
% rects -  nx4 matrix where each row is a rect
%
% params may include:
% 'sz' - scale the each rectangle to this size: sz * (max of rectSize(rects)) (def. 1) 
% 'margin' - add a margin around the rects (see rectEnlargeFac) (def. 20%)
%         Note: this margin is not included in sz, so an sz = 10x10 with margin=20%
%         will procude a final size of [14x14];
% 'lev' - which level to start the warp from.  Either 
%         1) a number: 1-4 (default: 1)
%         2) or a string: determine automatically the best level to warp from
%            'nearest' - choose a fixed level that will require the least scaling
%               on average
%            'down' - choose a level that will allways downsample
%            'var_near' and 'var_down' - same as above, but the best level is 
%               computed for each frame seperately (so different frames may
%               come from different levels)
%  
% to make a movie of the output see makeMovie.
%
% Example: show a movie of a perfect track
%  ims = trkSequence(fs, rects);
%  %show movie....
%  makeMovie(ims, 2, 10, 2);
%
  params = struct('sz', 1, 'margin', 0.2, ...
		      'lev', 1);
  params = vl_argparse(params, varargin);
  
  sz=params.sz;
  s = rectSize(rects);
  [~,maxidx] = max(prod(s,2));
  sz = sz*s(maxidx,:);
  
  rect = [0.5 sz(1)+0.5 0.5 sz(2)+0.5]; 
  rectMarg = rectRound(rectEnlargeFac(rect, params.margin));
  
  levs = zeros(size(rects,1),1);
  if(ischar(params.lev))
    s = rectSize(rects);
    if(strcmp('nearest', params.lev))
      ms = mean(s);
      lev_offset = round(mean(log2(sz./ms)));
    elseif(strcmp('down', params.lev))
      ms = min(s);
      lev_offset = ceil(mean(log2(sz./ms)));
    elseif(strcmp('var_near', params.lev))
      lev_offset = round(mean(log2(dtimes(sz, 1./s)),2));            
    elseif(strcmp('var_down', params.lev))
      lev_offset = ceil(mean(log2(dtimes(sz, 1./s)),2));            
    else
      lev_offset = -inf;
    end
    levs(:) = max(1, 1-lev_offset);
  else
    levs(:) = params.lev;
  end

  ims = [];
  
  for i=1:size(rects,1)
    coi = fs.readNextImage();
    for li=2:levs(i)
      coi = coiReduce(coi);
    end
    crect = rects(i,:);
    
    mot = rect2uvs(crect, rect);
    wcoi = coiPad(uvsWarp(mot, coi, rectMarg), rectMarg);
    ims(:,:,i) = wcoi.im(:,:,1);
  end
  