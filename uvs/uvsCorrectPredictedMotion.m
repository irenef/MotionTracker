function finalMot = uvsCorrectPredictedMotion(predMot, corrMot)
% uvsCorrectPredictedMotion   add to predicted motion the
%           correction that was found by tracking from image1 to
%           image2-backward-warped-by-predicted-motion.
%
% finalMot = uvsCorrectPredictedMotion(predMot, corrMot)
%
% predMot - a uvs motion
% corrMot - correction that was found by tracking from image1 to
%           image2-backward-warped-by-predicted-motion.
%
% finalMot - the new motion

finalMot = uvsPlus( corrMot, predMot );
finalMot = uvsChangeCenter( finalMot, uvsGetMotCenter( predMot ) );

end