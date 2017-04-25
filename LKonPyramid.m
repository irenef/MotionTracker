function [mot, dbg] = LKonPyramid(prevPyr, curPyr, prect, init_mot, varargin)
% LKonPyramid  perform Lukas-Kande on multiresolution image pyramid
%
% [mot, dbg] = LKonPyramid(prevPyr, curPyr, prect, init_mot, params)
%
% finds the image within rectangle prect of the previous frame (prevPyr) in 
%   the current frame (curPyr), using Lukas-Kanade tracking within the pyramid
% mot is a uvs vector [x y scale x_0 y_0] (see functions uvs* )
% params is defined by LKinitParams
%
% Note: All motions (input and output) are expressed in the base level of
% the input pyramids (prevPyr{1}.level).
%
% features:
%    if params.domedian==1, the images are median adjusted at the beginning of 
%       each level
%    if any(params.constraints), then constraints are added into the A'A matrix
%       to limit the amount of motion in each dimention
%    if params.do_scale==t, then scale is optimized, else it is kept equal
%       to init_mot's scale
%
%    debugging - if params.show_fig~=0, then we open figures for each level and
%                show the motion and residual error after each iteration 
%
% this calls LKonCoImage for each level
  
  % set default optional parameters
  params = LKinitParams(varargin{:});
  
  assert(prevPyr{1}.level==curPyr{1}.level, ...
	 'Pyramid base levels must be the same.');
 
  %what levels of the pyramid should we run over
  Ls = defineActiveLevels(prect, prevPyr, curPyr, params);
  
  mot = init_mot;
  plev = prevPyr{1}.level;
  dbg.mot = init_mot;
  
  %do tracking in each level
  for lev=Ls(end-1:-1:1)
    %change motion level
    mot = uvsChangeLevel(mot, plev, lev);
    lprect = rectChangeLevel(prect(min(end,lev+1),:), 1, lev);
    cparams = params;  % reset current copy of params
    
    % if num pixels is less then min_pix(2), estimate only u,v 
    % on this lev
    if(prod(rectSize(lprect))<params.min_pix(end))
      cparams.do_scale=false;
    end
    
    % debug: set figure number
    if(params.show_fig) 
      cparams.show_fig=params.show_fig+lev*100; 
      mdisp('Lev ', prevPyr{lev}.level, ' in ', uvs2String(mot), ' : ', rect2int(lprect));
    end
    plev=lev;
    
    % track in this level
    [mot, err, imot] = LKonCoImage(prevPyr{lev}, curPyr{lev}, ...
				   lprect, mot, cparams);
    
    %record dbg history
    dbg.mot(lev,:)=mot; 
    dbg.err(lev,1)=err;
    dbg.imot{lev}=imot; %iteration debug info
  end
  
  % change motion back to level 1 (in case last level was not 1)
  % Note: this 'lev' is the index of level (as in pyr{lev}, not
  % neccessarily the real level (as in pyr{lev}.level).
  % Thus the motion is always given in the base level of the pyrmaid.
  mot = uvsChangeLevel(mot, plev, 1);
  