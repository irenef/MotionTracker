function rect = coiImageRect(coi)
% coiImageRect   get imageRect from coimage 
%
% rect = coiImageRect(coi) 
%   rect is [left right bottom top]
  
  s = size(coi.im);
  rect = [1 s(2) 1 s(1)]-coi.origin([1 1 2 2])+[-0.5 0.5 -0.5 0.5];
  