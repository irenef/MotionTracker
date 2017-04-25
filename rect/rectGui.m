function rect = rectGui(rect, redo_until_done)
% rectGui   interactively define rect
%
% rect = rectGui(init_rect, redo_until_done)
%
% init_rect - (o) initial location of rect
% redo_until_done - (o) take first rectangle drawn, or allow redraw until quit
%
% This function allows the user to draw a rectangle on the current figure.  
% If redo_until_done==0, (default) the function takes the first rectangle drawn,
%  otherwise, the rect can be drawn over and over until a keyboard button is 
%  pressed.
%
% Example:
%   imageme(mei);
%   rect = rectGui; 
  
  if(exist('rect')==1 & length(rect)==4)
    rectDraw(rect,'r');
  end

  rect=[];
  while(1)
    k = waitforbuttonpress;
    if(k>0)
      break;
    end
    point1 = get(gca,'CurrentPoint');    % button down detected
    rbbox;                               % box drawing gui
    point2 = get(gca,'CurrentPoint');    % button up detected
    point1 = point1(1,1:2);              % extract x and y
    point2 = point2(1,1:2);
    
    if(exist('rect')==1 & length(rect)==4) % gray out previous one
      rectDraw(rect,[0.5 0.5 0.5]);
    end
    
    rect = points2rect(point1, point2);

    rectDraw(rect,'r');
    if(nargin<2 | ~redo_until_done)
      break;
    end
  end