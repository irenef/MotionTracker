function c = toColor(l);
% toColor  convert a letter or number to an rgb color value
%
% c = toColor(l)
%
% l - can be any of
%  char:  r g b c m y k o p u w
%  number: 
%     0<= l <1:  gets color from "jet" colormap
%     otherwise: gets asigned one of the above colors in order, modulo 10
%  if l is an [r g b] color already , then c=l
%  if l = [], then [1 0 0] (red) is returned...
%
% c - [ r g b ] color value, where each number is  0 <= r,g,b <= 1

  
  colors = {'r','g','b','c','m','y','k','o','p','u'};
  if(length(l)==0)
    c = [1 0 0];
    return;
  end
  
  if(isnumeric(l))
    if(size(l,2)==1)
      if(all(l>=0 & l<1))
	a = jet;
	c = a(round(l*63)+1,:);
        return;
      else
	l=cat(1,colors{mod(round(l)-1,10)+1});
      end
    elseif(size(l,2)==3)
      c=l;
      return;
    end
  end
  
  for i=1:size(l,1)
    switch l(i)
     case 'r'
      c(i,:) = [1 0 0];
     case 'g'
      c(i,:) = [0 1 0];
     case 'b'
      c(i,:) = [0 0 1];
     case 'c'
      c(i,:) = [0 1 1];
     case 'm'
      c(i,:) = [1 0 1];
     case 'y'
      c(i,:) = [0.9 0.7 0];
     case 'k'
      c(i,:) = [0 0 0];
     case 'o'
      c(i,:) = [1 0.5 0];
     case 'p'
      c(i,:) = [1 0 0.5];
     case 'u'
      c(i,:) = [0.5 0 0.5];
     case 'w'
      c(i,:) = [1 1 1];
     otherwise
      c(i,:) = [1 0.5 0];
    end
  end
