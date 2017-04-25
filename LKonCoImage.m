function [mot, err, imot] = LKonCoImage(prevcoi, curcoi, prect, init_mot, params)
% LKonCoImage   find the motion of rect from prev image to cur image
% 
% [mot, err, imot] = LKonCoImage(prevcoi, curcoi, prect, init_mot, params)
%
% single pyramid level of Lukas-Kanade    
%
% mot - final motion
% err - error of final motion
% imot - debug results of each iteration 
 
 
%init variables
  max_iter=params.max_iter;
  mot=init_mot;
  pmot = mot;
  perr = inf; err=inf;
  ps = size(prevcoi.im);
  
  NC = size(prevcoi.im,3);
  assert(NC==1, 'Only single channel images are implemented');
  CH=1; % only single channel 
  
  % cut out relevant rectangle (last argument is border for dx,dy)
  pcut1 = coiCut(prevcoi, prect, 1);
  roverRect = prect; 
    
  %---------------------
  % do tracking iterations
  exitcond = 'many_iter';
  spcutlast=0;
  for iter=1:max_iter
    
    %warp 'curent' (2nd) image according to motion
    wcoi = uvsBackwardWarp(mot, curcoi, coiImageRect(pcut1));
    
    % make sure that the 2 images are the same by cutting pcut more
    % in case wcoi is smaller (because it is slightly out of the image)
    pcut = coiCut(pcut1, coiImageRect(wcoi));
    
    %compute A'A when needed:
    %we compute A'A on first iteration or when cut rectangle has changed 
    % (due to warp near the border of the image)
    if(iter==1 || any(size(pcut.im)~=spcutlast))
      spcutlast = size(pcut.im);
      % check if we still have enough pix to track...
      if(prod(spcutlast(1:2))<params.min_pix(end) || any(spcutlast(1:2)<3))
        exitcond = 'out_of_image';
        break;
      end
      
      %set up variables for easy access
      pcrect = coiImageRect(pcut); % previous cut rect 
      pcrs = rectSize(pcrect); % size of the previous cut rect
      npix = numel(pcut.im(:,:,CH)); 
      
      %  compute derivative images... (these images will have same size as pcut)
      prevcoich = coiCut(prevcoi, rectEnlarge(coiImageRect(pcut),1));
      prevcoich.im = prevcoich.im(:,:,CH);
      [dx,dy] = coiGradient(prevcoich,'shape','valid'); % compute dx, dy gradient of image
      if(params.do_scale == 0)
        % compute A=[dx1 dy1;dx2 dy2;...]
        %------------------ fill in here for part 2.1
        A(:,1) = dx.im(:);
        A(:,2) = dy.im(:);
        %------------------ end fill in
      else
        % compute A=[dx1 dy1 ww1; dx2 dy2 ww2;...] 
        % where ww = x_pos.*dx + y_pos.*dy; 
        [x_pos,y_pos] = coiPixCoords(pcut);
        %---------------------- fill in here for part 2.2
        ww = (x_pos).*dx.im + (y_pos).*dy.im; 
        A(:,1) = dx.im(:);
        A(:,2) = dy.im(:);
        A(:,3) = ww(:); 
        %------------------ end fill in
      end
      
      % compute AtA and AtAinv
      %-------------------------- fill in here
      AtA = A'*A;
      AtAinv = pinv(AtA);
      %-------------------------- end fill in
    end  %of AtA computation...
    
    %compute It (error between previous and warped current) 
    It = pcut.im(:,:,CH)-wcoi.im(:,:,CH);
    
    % compute mot_update b solving Ax=b using x=inv(A'A)A'b
    %----------------------- fill in here
    Atb = A' * It(:);
    x = AtAinv*Atb;
    
    %----------------------- end fill in
    
    err = sum(It(:).^2)/npix;

    % draw debug figure
    if(params.show_fig)
      hh = figure(params.show_fig+min(1,iter-1)); clf;
      set(hh, 'Name', ['Lev ' num2str(prevcoi.level)]);

      % show cut prev image
      subplot(3,1,1);
      pcut_CH = pcut; 
      pcut_CH.im = pcut_CH.im(:,:,CH);
      imageco(pcut_CH); title(['Previous L=' num2str(prevcoi.level)]); hold on; grid on;
      plot(mot(4), mot(5), 'r+');
      set(gca, 'GridColor', 'r', 'LineWidth', 2);
      
      subplot(3,1,2);
      wcoi_CH = wcoi; wcoi_CH.im = wcoi_CH.im(:,:,CH);
      imageco(wcoi_CH); grid on;
      title(['Warp Current I=', num2str(iter-1), char(10), 'uvs ' uvs2String(mot, false) '']);
      set(gca, 'GridColor', 'r', 'LineWidth', 2);
      hold on; plot(mot(4), mot(5), 'r+');
      
      subplot(3,1,3);
      imagecosc(coimage(sum(It,3), pcut.origin, 'ssd')); %colorbar; 
      title(['err=' num2str(err)]);
      grid on; set(gca, 'GridColor', 'r', 'LineWidth', 2);
      %coiQuiver(pcut2, itdx, itdy, 0*max(1,min(5,size(mit,1)*0.05)));
      mdisp('  Err ', iter-1, ': ', num2str(err,'%.6f')); 
      pause(0.2);
    end

    %exit condition: error increased 
    if(err-perr > params.err_change_thr)
      mot = pmot;
      err = perr;
      exitcond = 'inc_error';
      break;
    end
    perr=err;
    pmot=mot;
    
    %update motion
    motNew = mot; %init with previous motion
    
    %update:
    if(params.do_scale == 0)
      %------------------ fill in here for part 2.1
      motNew(1,1) = mot(1,1)+x(1,1);
      motNew(1,2) = mot(1,2)+x(2,1);
      %------------------ end fill in
    else 
      %---------------------- fill in here for part 2.2
      motNew(1,1) = mot(1,1)+x(1,1)+x(1,1)*mot(1,3);
      motNew(1,2) = mot(1,2)+x(2,1)+x(2,1)*mot(1,3);
      motNew(1,3) = mot(1,3)+x(3,1)+x(3,1)*mot(1,3);
      %------------------ end fill in
    end
    %motNew(1,4:5) = rectCenter(prect);
    mot = motNew;
    
    % debugging
    imot.pmot(iter,:) = pmot;
    imot.mot(iter,:) = mot;
    imot.err(iter,:) = err;
    
    if(mot(3)<-0.99)
      mot = pmot;
      err = perr;
      exitcond = 'invalid_scale';
      break;
    end
        
    if(params.show_fig)
      mdisp('  New mot ', iter, ': ', uvs2String(mot)); 
    end
    
    %exit condition: check for insignificant motion
    if(abs(pmot(1)-mot(1))< params.uvs_min_significant(1) && ...
        abs(pmot(2)-mot(2))<params.uvs_min_significant(2) && ...
        abs(pmot(3)-mot(3))<params.uvs_min_significant(3))
      exitcond = 'insig_mot';
      break;
    end  
  %}
  end %iterations
  
  if(params.show_fig)
    title(['err=' num2str(err), char(10), exitcond]);
    mdisp('  Final Lev Mot: ', uvs2String(mot), ' iters: ', iter, ...
	  ' exit: ', exitcond);  
  end
    
   
  
  % BH: debugging
  imot.exitcod = exitcond;
  imot.iter = iter-1;
  imot.fmot = mot;
  % HB
