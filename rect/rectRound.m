function rrect = rectRound(rect, varargin)
% rectRound   round a rectangle (so either all or none of each pixel is included)
%
% rrect = rectRound(rect, offset)
%
% offset - (o) see rect2int
%
% this just does:
%   rrect = int2rect(rect2int(rect, offset));
%
  
  
  rrect = int2rect(rect2int(rect, varargin{:}));