function [rects, dbg] = LKonSequence(fs, varargin)
% LKonSequence  run Lukas-Kanade using incremental tracking on a sequence
%
% [rects, dbg] = LKonSequence(fs, varargin)
% fs - is a FaceSequence class. Set fs.next and fs.step to define the
%      frames 
% optional parameters:
%   'length' - number of frames to track to: fs.next+(1:length)*fs.step
%   'init_rect', % if not given, uses fs.gt_rect(fs.next,:)
%   'init_mot', % initial motion between first 2 frames

  % number of frames to run on
  seq_params.length = 10; 
  
  % initial rect in first frame
  seq_params.init_rect = fs.gt_rect(fs.next,:);
  [seq_params, varargin] = vl_argparse(seq_params, varargin); % update seq_params with opt inputs
  
  % initial motion from frame 0->1 
  seq_params.init_mot = [0 0 0 rectCenter(seq_params.init_rect)];
  
  [seq_params, varargin] = vl_argparse(seq_params, varargin);
  lk_params = LKinitParams(varargin{:});
  
  % init rects - first line is frame 0...length
  rects = repmat(seq_params.init_rect, seq_params.length+1, 1);

  % init mots - rows are 0->1, 1->2, ..., (length-1 -> length)
  mots = repmat(seq_params.init_mot, seq_params.length, 1);

  prevPyr = coPyramid(fs.readNextImage());
  dbg = cell(seq_params.length,1);
  init_mot = seq_params.init_mot;
  
  for i=1:seq_params.length    
    curPyr = coPyramid(fs.readNextImage());
    
    % now call LK and fill in result rects and mots, make prediction for
    % next motion (making some assumption that the motion is smooth) 
    % note: recall that the x0,y0 componenets of the init_mot 
    % should be near the prect center 
    
    %%------------------- fill in here
    [mot, fdbg] = LKonPyramid(prevPyr, curPyr, rects(i,:), init_mot, lk_params);
    mots(i+1,:) = mot;
    rects(i+1,:) = uvsRWarp(mot, rects(i,:));
    init_mot = mot;
    init_mot(1,4:5) = rectCenter(rects(i,:));
    
    %%---------------------- end fill in
    dbg{i}=fdbg;
    
    mdisp('Tracking ', i, ' to image ', curPyr{1}.label, ' motion ', uvs2String(mot), ' rect ', rects(i+1,:));
    prevPyr = curPyr;
    
  end
  
  
  