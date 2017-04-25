function ra = roundto(a,fracto)
% roundto   rounds to nearest value with given fractional part
%
% ra = roundto(a,fracto) 
%
% rounds a to the nearest value which has fractional component of 
%     the values in fracto
% 
% a, fracto must have loosly matching sizes - see dplus 
  
  f = mod(fracto,1);
  ra = dplus( floor(dplus(a,-f)+0.5), f);