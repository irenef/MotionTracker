function c = coi2imcoord(coi, c)
% coi2imcoord   convert coi image coord or rect c to image coord/rect 
%
% imc = coi2imcoord(coi, meic)
%
% the output coords imc can be use to access actual pixels
%
  
  if(size(c,2)==2)
    c = [c(:,1)+coi.origin(1) c(:,2)+coi.origin(2)];
  elseif(size(c,2)==4)
    c = [c(:,1)+coi.origin(1) c(:,2)+coi.origin(1) ...
	 c(:,3)+coi.origin(2) c(:,4)+coi.origin(2)];
  end
  