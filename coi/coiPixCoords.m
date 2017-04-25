function [cx,cy] = coiPixCoords(coi)
% coiPixCoords   compute the x,y coordinates of each pixel 
%
% [cx,cy] = coiPixCoords(coi)
%
% [cx, cy] - are matricies of the same size as coi.im -- similar to meshgrid

  r = coiImageRect(coi);
  [cx,cy] = meshgrid(r(1)+0.5:r(2)-0.5,r(3)+0.5:r(4)-0.5);
  