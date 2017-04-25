function c = rectCenter(r)
% rectCenter  returns center of rect(s) r
%
% c = rectCenter(r)
  
  c = [mean(r(:,1:2),2) mean(r(:,3:4),2)];  
  