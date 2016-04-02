function [u,v] = LucasKanadeOpticalFlow(I1, I2, WindowSize,MaxIter,NumLevels)
    
    i_resized = cell(1, NumLevels);
    i_resized{1, NumLevels} = I1;
    i_resized{2, NumLevels} = I2;
    
    for level = [1:NumLevels-1]
        i_resized{1, NumLevels-level} = imgaussfilt(i_resized{1, NumLevels-level+1});
        i_resized{1, NumLevels-level} = i_resized{1, NumLevels-level}(1:2:end, 1:2:end);        
        i_resized{2, NumLevels-level} = imgaussfilt(i_resized{2, NumLevels-level+1}) ;
        i_resized{2, NumLevels-level} = i_resized{2, NumLevels-level}(1:2:end, 1:2:end);
    end
    
    p = [0; 0];    

    for loop = [1:MaxIter]        

        warp(:,:,1) = ones(size(I2))*p(1);
        warp(:,:,2) = ones(size(I2))*p(2);

        [ix, iy] = gradient(I2);
        ixx = sum(sum(imwarp(imfilter(ix.*ix, ones(WindowSize, WindowSize)), warp)));
        iyy = sum(sum(imwarp(imfilter(iy.*iy, ones(WindowSize, WindowSize)), warp)));
        ixy = sum(sum(imwarp(imfilter(ix.*iy, ones(WindowSize, WindowSize)), warp)));


        it = imwarp(I2, warp) - I1;

        B = [ixx, ixy;
             ixy, iyy];


        B_it = [sum(sum(imfilter(ix.*ix, ones(WindowSize, WindowSize)).*it));
                sum(sum(imfilter(iy.*iy, ones(WindowSize, WindowSize)).*it))];

        delta_p = -inv(B)*B_it;

        p = p + delta_p;

    %    reshape(I1, 1,[])'

    end

end