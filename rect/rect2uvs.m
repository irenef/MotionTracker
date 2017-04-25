function mot = rect2uvs(r1, r2)
% rect2uvs  compute uvs from 2 rectangles
%
% mot = rect2uvs(r1, r2)
%
% r1 -> r2 -  the rectangles 
%
% if the 2 dimentions of scale are not the same, then their scale is averaged...
  
  c1 = rectCenter(r1); s1 = rectSize(r1);
  c2 = rectCenter(r2); s2 = rectSize(r2);

  scaleW = (s2(:,1)-s1(:,1))./s1(:,1);
  scaleH = (s2(:,2)-s1(:,2))./s1(:,2);
  s = (scaleW+scaleH)./2;
  u = r2(:,1)-r1(:,1)-(r1(:,1)-c1(:,1)).*s;
  v = r2(:,3)-r1(:,3)-(r1(:,3)-c1(:,2)).*s;
  mot = [u v s c1(:,1) c1(:,2)];

