function str = uvs2String(mot, show_center)
% uvs2String  format tsuv motion to a string for printing
%
% str = uvs2String(mot, show_center)
% show_center - (o) print center location (def. 1)
  
  if(nargin<2 | any(show_center))
    str = sprintf('<%0.2f %0.2f %0.3f (%0.0f,%0.0f)>', mot(1:5));
  else
    str = sprintf('<%0.2f %0.2f %0.3f>', mot(1:3));
  end