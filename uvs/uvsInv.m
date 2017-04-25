function motinv = uvsInv(mot)
% uvsInv  invert the transScaleUV motion 
%
% motinv = uvsInv(mot)
%
% motinv is defined such that: 
%    uvsPlus(mot,motinv) -> zero motion with center at mot's center;

% create a random rectangle, warp it, get the new coordinates
rect0 = zeros(size(mot,1), 4); 
rect0(:,1) = 0;
rect0(:,2) = 2;
rect0(:,3) = 0; 
rect0(:,4) = 4;
rect1 = uvsRWarp(mot, rect0);
wh0 = rectSize(rect0);
wh1 = rectSize(rect1); 

u = -mot(:,1);
v = -mot(:,2);
s = (wh0(:,1)-wh1(:,1))./wh1(:,1);
x0 = mot(:,4);
y0 = mot(:,5);

Xinds = 1:2:size(s,2)*2;
Yinds = 2:2:size(s,2)*2;

c(:,Xinds) = transpose(x0); 
c(:,Yinds) = transpose(y0);
update_mot(:,4) = x0;
update_mot(:,5) = y0; 
update_mot(:,1) = u;
update_mot(:,2) = v;
update_mot(:,3) = s; 
wc = uvsCWarp(mot, c);
motinv = update_mot;
motinv(:,4:5) = wc;

end