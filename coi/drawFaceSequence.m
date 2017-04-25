function drawFaceSequence(fs, from, step, number, rects)
% drawFaceSequence  
%
% drawFaceSequence(fs, from, step, number, rects)
  fs.next=from; fs.step=step;
  
  for n = 1:number 
    index = 1+step*(n-1);
    imageco(fs.readNextImage(), 1, 1); % what to put for dynamic range and level?
    if(nargin>=5)
      % rectDraw(fs.gt_rect(index,:));
      rectDraw(rects(n,:));
    end
    pause(0.2);

  end
  
end
