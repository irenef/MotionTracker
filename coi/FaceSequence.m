classdef FaceSequence < handle
%  FaceSequence  class handles reading in data from the sequences
%    downloaded from http://vision.ucsd.edu/~bbabenko/data/miltrack/
% 
% to initialize:
%  fs = FaceSequence('path/to/data/girl');
%
% Now to access the images, you can (method 1) 
%  coi = fs.readImage(5); 
% will read the 5th image (NOTE: this is probably image img00004.png - don't be confused)
% and read it into a coimage struction (help coimage)
% If you want to access a sequence of images, say every 3rd image starting
% from the 2nd, do (method 2)
%   fs.next=2; fs.step=3;
%   coi1 = fs.readNextImage(); % the 2nd
%   coi2 = fs.readNextImage(); % the 5th
%   so on.. 
% Additionally, fs contains the "ground truth" rectangles stored with the
% clip in 
%    rect = fs.gt_rect(1,:); % rectangle for 1st image
% Beware: only some frames have valid ground truth rectangles, otherwise
% this rect = [0 0 0 0]; 

  properties
    dpath
    image_pattern
    im_number
    step
    next
    gt_good
    gt_rect
  end
  
  methods 
    function obj = FaceSequence(dpath_in)
      obj.dpath = dpath_in;
      [~,name] = fileparts(dpath_in);
      obj.image_pattern = [obj.dpath '/imgs/img%05d.png'];
      irng = dlmread([obj.dpath '/' name '_frames.txt'], ',');
      obj.im_number = irng(1):irng(end);
      obj.step = 1;
      obj.next = 1;
      R = dlmread([obj.dpath '/' name '_gt.txt']);
      obj.gt_rect = [R(:,1) R(:,1)+R(:,3) R(:,2) R(:,2)+R(:,4)]-0.5;
      obj.gt_good = find(sum(R,2)>0);
    end
    
    function coi = readImage(fs, idx)
      if(idx<1 || idx>length(fs.im_number))
        error('readImage:outofrangeidx', 'index out of range');
      end
      number = fs.im_number(idx);
      im = imread(sprintf(fs.image_pattern, number));
      im = double(im(:,:,1))/255;
      coi = coimage(im, [0 0], sprintf('img%05d', number), 1);
    end

    function coi = readNextImage(fs)
      coi = readImage(fs, fs.next);
      fs.next = fs.next + fs.step;
    end
    
  end
end

  
  