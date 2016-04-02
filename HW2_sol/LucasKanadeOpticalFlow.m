function [u,v] = LucasKanadeOpticalFlow(I1, I2, WindowSize,MaxIter,NumLevels)
    p = [0,0];

    warp(:,:,1) = ones(size(I2))*p(1);
    warp(:,:,2) = ones(size(I2))*p(2);
    
    [ix, iy] = gradient(I2);
    ixx = sum(sum(imwarp(imfilter(ix.*ix, ones(WindowSize, WindowSize)), -warp)));
    iyy = sum(sum(imwarp(imfilter(iy.*iy, ones(WindowSize, WindowSize)), -warp)));
    ixy = sum(sum(imwarp(imfilter(ix.*iy, ones(WindowSize, WindowSize)), -warp)));
    
%     If warp is positive, the image is pushed upwards and to the left,
%     contrary to what we calculated in classb
    it = imwarp(I2, -warp) - I1;
    
    B = [ixx, ixy;
         ixy, iyy];
     
%      Stopped here. Need to calculate B*it. Notice that I need to consider
%      the window size
     
    B_it = [sum(sum(ix.*it))
     
%     delta_p = 
   
%    reshape(I1, 1,[])'

end