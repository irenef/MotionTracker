function h = rectDraw(rect, col, varargin)
% rectDraw   draw rectangle(s) on top of an image
%
% h = rectDraw(rect ,col, rectangle_params...)
%
% rect - format [left right bottom top] (can be matrix with multiple rows of rects)
% col - (o) color of the line either [r g b], number, or char (see
%           toColor).  You can also set the color for each rect by
%           a 5th column of rect ([l r b t color]). (def. 'g')
% rectangle_params... - (o) sent in to the matlab function rectangle
%
% h - handle to rectangle object
%
% The rectangles are allways plotted on top of the current figure -- there is 
% no need to call a "hold on" beforehand.
%
% Example:
%   imageme(mei); 
%   rectDraw([-10 10 15 22]);
%   rectDraw([-10.5 15.2 20.8 30.5], 'r', 'Curvature', [.2 .2]);

 
  if isempty(rect), return; end

  if(nargin<2 || isempty(col))
    if(size(rect,2)>4)
      col = toColor(rect(:,5));
    else
      col = [0 1 0];
    end
  else
    col = toColor(col);
  end
  corners=false;
  if(length(varargin)>=1 && strcmpi(varargin{1}, 'Corners'))
    corners=true;
    varargin=varargin(2:end);
  end
  if(size(rect,2)>=4)
    h=zeros(size(rect,1),1);
    for i=1:size(rect,1)
      if(corners)
        plot(rect(i,[1 1 2 2]), rect(i,[3 4 3 4]), '+', 'color', col(min(end,i),:), varargin{:});
      else
        w = max(eps, rect(i,2)-rect(i,1));
        hg = max(eps, rect(i,4)-rect(i,3));
        h(i) = rectangle('Position', [rect(i,1) rect(i,3) w hg], ...
          'EdgeColor', col(min(end,i),:), ...
          varargin{:});
      end
    end
  else
    w = max(eps, rect(2,2)-rect(1,2));
    hg = max(eps, rect(2,1)-rect(1,1));
    h = rectangle('Position', [rect(1,2) rect(1,1) w hg], ...
                  'EdgeColor', col(min(end,i),:), ...
		  varargin{:});
  end
  
  if(nargout<1)
    clear h;
  end
  
  
  %  line([rect(1,2) rect(1,2) rect(2,2) rect(2,2)], ...
  %       [rect(1,1) rect(2,1) rect(2,1) rect(1,1)]);

