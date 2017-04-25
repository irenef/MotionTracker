function nmot = uvsChangeLevel(mot, oldlev, newlev)
% uvsChangeLevel  change the pyramid level of the motion 
%
% nmot = uvsChangeLevel(mot, oldlev, newlev)
% 

    factor = 2^(oldlev-newlev);
    nmot(:,1:2) = mot(:,1:2).*factor;
    nmot(:,4:5) = mot(:,4:5).*factor;
    nmot(:,3) = mot(:,3);
    
end