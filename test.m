% hw3 test script

% this file should not be run as a whole - cut 'n paste bits as you
% work on them


%%%%%%%%%%%%%%%

% initialize paths
hw3start

% path to your data dir
data_dir = 'data/';

seq_name = 'girl'; 
seq_dir = fullfile(data_dir, seq_name);

% a few basic commands:
% read an image
im = imread(fullfile(seq_dir, 'imgs', 'img00004.png'));

% make coimage:
coi = coimage(im); 

% display it
figure(5); clf; 
imageco(coi);

% gui for drawing a rectangle on the image 
rect = rectGui()

% let's define a rect: [xmin xmax ymin ymax]
rect1 = [145.5228  241.2306   63.1484  158.1256] 

% and a motion (with center of motion at center of rect1) : mot = [u v s x0 y0] 
mot = [13 10.5 0.09 rectCenter(rect1)] 

% to warp rect1 according to mot, do
rect2 = uvsRWarp(mot, rect1)


%%%%%%%%%%%%%%% 1.1

% first, you should edit uvs/uvsInv.m

% test it (include the output of these commands in your submission)
moti = uvsInv(mot)
rect1_new = uvsRWarp(moti, rect2) % should be same as rect1
% check if it was correct:
sum(abs(rect1_new - rect1))<1e-10
% check if it can handle multiple rows:
mots = uvsInv([mot;moti])  % show output of this


%%%%%%%%%%%%%%% 1.2

% now edit rect/rect2uvs.m

% test it (include the output of these commands in your submission)
mot2 = rect2uvs(rect1, rect2)
% check it:
sum(abs(mot-mot2))<1e-10
% test multiple inputs:
mots = rect2uvs([rect1;rect2], [rect2;rect1])


%%%%%%%%%%%%%%% 1.3

% loading and manipulating a face sequence
fs = FaceSequence(seq_dir)
coi_1 = fs.readImage(5); % same image as coi defined above
fs.next=2; 
fs.step=3;
coi1 = fs.readNextImage(); % the 2nd
coi2 = fs.readNextImage(); % the 5th %same as coi above

% now implement coi/drawFaceSequence.m

% note: for 'girl' the ground truth is defined only for frames 1,6,11,16...
% the following should display a movie of frames 1:5:51 with a rect drawn
% around the face:
%drawFaceSequence(fs, 1, 5, 10, fs.gt_rect(1:5:51,:));


%%%%%%%%%%%%%%% 2.1

% now implement the translation-only part of LKonCoImage.m

% test it on frames 1 and 6 of the girl sequence
fs.next=1;
fs.step=5;
prect = fs.gt_rect(fs.next, :)
init_mot = [0 0 0 rectCenter(prect)]
prevcoi = fs.readNextImage();
curcoi = fs.readNextImage();
params = LKinitParams();
params.do_scale = 0;
params.show_fig = 1;

% you should see an animation with the error image becoming relatively blue
% (indicating low error)
%[mot, err, imot] = LKonCoImage(prevcoi, curcoi, prect, init_mot, params)


%%%%%%%%%%%%%%% 2.2

% now implement the translation-scale part of LKonCoImage.m

% test it
prect = fs.gt_rect(41,:);
init_mot = [0 0 0 rectCenter(prect)];
prevcoi = fs.readImage(41);
curcoi=fs.readImage(43);
params.max_iter = 40;

% notice in the visualization that single-scale LK does the best it can, but
% there is still error around the outside of the face
%[mot, err, imot] = LKonCoImage(prevcoi, curcoi, prect, init_mot, params)

% now run the (u,v,s) version - notice that the final error is lower, and
% that eventually it converges to the right scale
%params.do_scale = 1;
%[mot, err, imot] = LKonCoImage(prevcoi, curcoi, prect, init_mot, params)


%%%%%%%%%%%%%%% 2.3

% experiment with various pairs of frames in the 'girl' and 'david' sequences
fs = FaceSequence(seq_dir);
fs.next=1;
fs.step=5;
params.do_scale = 0;
prect = fs.gt_rect(41,:);
init_mot = [15 15 0 0 0];
prevcoi = fs.readImage(41);
curcoi=fs.readImage(43);
params.max_iter = 100;


% notice in the visualization that single-scale LK does the best it can, but
% there is still error around the outside of the face
%[mot, err, imot] = LKonCoImage(prevcoi, curcoi, prect, init_mot, params)

%%%%%%%%%%%%%%% 3.1

% create pyramids for prevcoi and curcoi
prevpyr = coPyramid(prevcoi,5)
figure
imageco(prevpyr(1))
imageco(prevpyr(2))
imageco(prevpyr(3))
imageco(prevpyr(4))
imageco(prevpyr(5))
curpyr = coPyramid(curcoi,5)

% now implement defineActiveLevels.m

% test it - should only return the first 4 levels
defineActiveLevels(prect,prevpyr,curpyr,params)


%%%%%%%%%%%%%%% 3.2

% implement uvs/uvsChangeLevel.m

% check it - we're going *up* the pyramid, so motion should be smaller
mot2 = uvsChangeLevel(mot,1,2)
% sanity check
mot21 = uvsChangeLevel(mot2,2,1)
sum(abs(mot21 - mot))<1e-10


%%%%%%%%%%%%%%% 3.3

% test LKonPyramid

curpyr = coPyramid(fs.readImage(51),5);
init_mot = [0 0 0 0 0];
%mot = LKonPyramid(prevpyr,curpyr,prect,init_mot,'show_fig',1)


%%%%%%%%%%%%%%% 4

% fill in LKonSequence.m

% see if we can track the first 10 frames
fs = FaceSequence(seq_dir);
fs.next = 1;
fs.step = 1;
rects = LKonSequence(fs);
figure
%imageco(fs.readImage(41))
%rectDraw(rects(41,:))
drawFaceSequence(fs, 1, 1, 10, rects);

% now go forth and test!

