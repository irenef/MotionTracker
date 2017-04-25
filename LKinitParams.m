function params = LKinitParams(varargin)
% LKinitParams   init parameters for scale Lukas-Kanade algo 
%
% params = LKinitParams(params...)
% 
% params that exist in the input struct are not changed.
% So to initialize parameters to non-default values,
% just change those fields either before or after calling this function
%
% for a list of parameters and default values, just call this function with 
% no arguments.
    
  % do_scale - if false, don't compute scale parameter
  params.do_scale = true;

  %max_iter controls the maximum number of iterations per level
  params.max_iter = 10;

  %show_fig is a figure number. if show_fig~=0, then
  %  the tracker will make a figure(show_fig+level-1) for each level
  %  plus print dbg information... 
  params.show_fig = 0;

  %the maximum range of levels in which we should track
  params.max_lev_rng = [1 4]; 
  
  %minimum number of pixels needed for doing alignment
  % if 2-vector [a b], then b is min pixels to do scale estimateion 
  % if num-pix in level is x, where a<x<b, then only translation is 
  %  done (do_scale==false)
  params.min_pix = [16 25];

  % lower threshold for error increase from one iter to another
  params.err_change_thr = 0;
  
  % min threshold for a motion change during an iteration to be significant
  % if motion is less than this in all 3 DOFs, level is considered
  % converged
  params.uvs_min_significant = [0.005 0.005 0.0005];
  
  %% optional extensions: 
  
  %if true, the images are median normalized
  params.domedian=false;   

  %L2 regularization: constraints applies constraints to the 3 dof
  % for each x, y, and s (for i=[1 3 5]):
  %    constraint = constraints(i)*npix + constraints(i+1)
  params.constraints = [0 0 0 0 0 0];  
  
  %use_channels - for multichannel images, defines which channel numbers to use
  % in optimization. if [], uses all. (ex. [1 3]) 
  % for example use, see sfPedTrack2Rect
  params.use_channels = [];
  
  % replace defaults with arguments...
  params = vl_argparse(params, varargin);

  