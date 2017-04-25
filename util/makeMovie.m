function mv = makeMovie(ims, varargin)
% makeMovie   make a movie from a sequence of images
%
% mv = makeMovie(ims, params)
%
% ims - sequence of images as a 3D matrix 
% 
% used parameters:
%
% show - number of times to show movie (see movie) (def. 1)
% fignum - figure number to draw into if show>0 (def. current figure)
% frame_pause - pause for this many seconds (or fraction of) between frames during the 
%           initial capturing of the frames (useful when show==0)
%
% Note: if show==0 and the 'mv' output is not used by the caller (nargout==0) then the
% movie is not actually created (just shown once). This is sometimes useful when creating 
% the movie causes an OUT_OF_MEMORY error. 
  
  
  params = struct('resize', [], 'fignum', [], ...
    'show', 1, 'colors', 0, ...
    'xy', 1, 'frame_pause', 0, ...
    'center', [0 0]);
  
  params = vl_argparse(params, varargin);

  %ims = im2uint8(ims);
  % resize images if asked for
  if(any(params.resize) && any(params.resize~=1))
    ims = imresize(ims,params.resize); 
  end
  
  %make movie
  %for i=1:size(ims,3);
  %  mv(i)=im2frame(ims(:,:,i), gray(256)); 
  %end;
  
  % if we were given a figure number, play it there...
  if(any(params.fignum))
    figure(params.fignum);
  end
  
  for i=1:size(ims,3);
    imageco(coimage(ims(:,:,i), params.center, num2str(i))); axis image;
    if(any(params.show) || nargout>0)
      mv(i)=getframe;
    end
    pause(params.frame_pause);
  end;
    
  %play movie if n~=0
  if(any(params.show))
    movie(mv,params.show);
  end
  