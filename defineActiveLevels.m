function Ls = defineActiveLevels(prect, mep1, mep2, params)
% defines the levels on which we need to operate...
% the rule is: there must be at least params.min_pix(1) 
% pixels to work on 

  nLev = 1; 
  %{
  prect = rectChangeLevel(prect, nLev, nLev+1);
  size = rectSize(prect);
  nPixels = size(1)*size(2);
  %}
  flag = false; 

  while (~flag)
    prect = rectChangeLevel(prect, nLev, nLev+1);
    size = rectSize(prect);
    nPixels = size(1)*size(2);
    if (nPixels < params.min_pix(1))
      flag = true;  
    else
      nLev = nLev+1;
    end
  end
  
  minlev = 1; 
  maxlev = nLev;
  Ls = minlev:maxlev;
  