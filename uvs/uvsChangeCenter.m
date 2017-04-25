function mot = uvsChangeCenter(motin, newcenter)
% uvsChangeCenter  change center of motion
%
% mot = uvsChangeCenter(motin, newcenter)
%
% the tricky thing is that we need to change u and v, such:
% u_new = u_old + s*( x0_new - x0_old )

% enum
X = 1;
Y = 2;
U = 1;
V = 2;
S = 3;
X0 = 4;
Y0 = 5;

mot = motin;
mot(:,X0) = newcenter(:,X);
mot(:,Y0) = newcenter(:,Y);
mot(:,U:V) = dtimes(mot(:,S),(mot(:,X0:Y0)-motin(:,X0:Y0)))+motin(:,U:V);
