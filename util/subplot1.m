function [subn] = subplot1(N,i,exsize,maxN,frac)
% subplot1  like subplot, but figures out how to arange the subplots in i and j
%
% subn = subplot1(N,i,exsize,maxN)
%
% N - number of plots needed (may be 0 if subplot1 was called on this figure before,
%         in which case the previous layout is kept)
%     If N is a 2-vector [ni nj], it defines the layout of subplots (similar to subplot)
%      -- this is still useful as, subplot1 has some several advantages to subplot. 
%
% i - current number 
%
% exsize - (o) example size of ploted image (for computing how many to place in i,j)
%              note: exsize is in (i,j) i.e. exsize=size(im);
%
% maxN - (o) max figures to allow (if N is smaller or larger, some subplots 
%            will cohabitate)
%
% subn - [yn xn cur_i handle];
  
  if(~any(N))
    % if subplot1 was called on this figure before, then the current figure has
    % its 'UserData' field set to a 4 vector.
    ud = get(gcf,'UserData');
    meAssert(length(ud)==4, 'subplot1: Can not figure out how many subplots there are.');
    yn = ud(1);
    xn = ud(2);
    N = ud(3);
    Nr = ud(4);
  else
    % if we were given the requested size in N
    if (length(N)==2)
      yn = N(1);     
      xn = N(2);
      N = yn*xn;
    end
    
    if(nargin<4 | ~any(maxN))
      Nr=N;
    else
      Nr=min(maxN,N);
      N=max(maxN,N);
    end
    
    %if we have not computed xn,yn above
    if(exist('xn')~=1)
      if(nargin<3 | length(exsize)<2)
	exsize=[1 1];
      end
      
      exsize=exsize+2;
      Nre = prod(exsize(1:2))*Nr;
      ne = sqrt(Nre);
      
      xn=round(ne/exsize(2));
      yn = ceil(Nr/xn);
      xn = ceil(Nr/yn);
    end
  end
  if(ceil(i*Nr/N)>(xn*yn))
    error('Requested subplot number too large');
  end
  if(~exist('frac'))
    h = subplot(yn,xn,ceil(i*Nr/N));
  else
    xsp = 1/xn; ysp = 1/yn;
    ind = ceil(i*Nr/N);
    [xi,yi] = ind2sub([xn yn], ind);
    r = [(xi-1)*xsp (yi-1)*ysp xsp ysp]+(1-frac)*[xsp/2 ysp/2 -xsp -ysp];
    r(2) = 1-r(2)-r(4);
    h = subplot('position', r);
  end
  subn=[yn xn ceil(i*Nr/N) h];
  
  set(gcf,'UserData',[yn xn N Nr]);
  
  