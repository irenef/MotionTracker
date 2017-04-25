function mdisp(varargin)
% mdisp   display multiple variables (strings, numbers, objects) 
%
% mdisp(v1, v2, ....)
% 
% numbers and strings are placed on the same line while all other
% types are printed on a new line with matlab's disp.

  nl = 0;
  prec = '%0.2f ';
  if(nargin>1 && ischar(varargin{end}) && length(varargin{end})>2 && varargin{end}(1)=='%')
    prec = [varargin{end} ' '];
    varargin = varargin(1:end-1);
  end
  for i=1:length(varargin)
    if(isnumeric(varargin{i}))
      if(all(varargin{i}(:)==round(varargin{i}(:))))
        fprintf('%s ', num2str(varargin{i}(:)'));
      else
        fprintf('%s ', num2str(varargin{i}(:)', prec));
      end
      nl=0;
    elseif(ischar(varargin{i}))
      if(isempty(varargin{i}))
        nl=1;
      else
        fprintf('%s',varargin{i}); 
        nl=0;
      end
    else
      if(~nl)
	fprintf('\n');
      end
      disp(varargin{i});
      nl=1;
    end
  end

  if(~nl)
    fprintf('\n');
  end
