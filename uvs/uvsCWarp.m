function wc = uvsCWarp(mot, c)
% uvsCWarp   warp a point or set of points according to mot
%
% wc = uvsCWarp(mot, c)
%
% mot - uvs motion
% c   - nx2, nx4, ... of coordinate pairs where each row is:
%       [x1 y1 x2 y2 ...]
%
% wc -  c, with the coordinates warpped
%
% remark: this function works in several possible scenarios:
%         1. single point and single motion
%         2. a  single point and multiple motions in multiple rows: each
%            motion will be applied to point spearately, and the output will
%            contain as many rows as 'mot'.
%         3. multiple points and a single motion: the motion will be
%            applied to each point separately. the output is the same size as
%            c.


% enum
U = 1;
V = 2;
S = 3;
X0 = 4;
Y0 = 5;

Xinds = 1:2:size(c,2);
Yinds = 2:2:size(c,2);

wc = c;
if(size(wc,1)==1)
  wc = repmat(wc, size(mot,1), 1);
end
wc(:,Xinds) = c(:,Xinds)+mot(:,U)+mot(:,S).*(c(:,Xinds)-mot(:,X0));
wc(:,Yinds) = c(:,Yinds)+mot(:,V)+mot(:,S).*(c(:,Yinds)-mot(:,Y0));

