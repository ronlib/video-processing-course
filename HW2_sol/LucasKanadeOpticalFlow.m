function [u,v] = LucasKanadeOpticalFlow(I1, I2, WindowSize,MaxIter,NumLevels)

    i_resized = cell(1, NumLevels);
    i_resized{1, NumLevels} = I1;
    i_resized{2, NumLevels} = I2;

    for level = [1:NumLevels-1]
        i_resized{1, NumLevels-level} = impyramid(i_resized{1, NumLevels-level+1}, 'reduce');
        i_resized{2, NumLevels-level} = impyramid(i_resized{2, NumLevels-level+1}, 'reduce');
    end

    p = [0; 0];

    for level = [1:NumLevels]
        for loop = [1:MaxIter]

            warp(:,:,1) = ones(size(i_resized{2, level}))*p(1);
            warp(:,:,2) = ones(size(i_resized{2, level}))*p(2);

            I2_current_warped = imwarp(i_resized{2, level}, warp);
            it = I2_current_warped - i_resized{1, level};

            [ix, iy] = gradient(I2_current_warped);
            ixx = sum(sum(imwarp(ix.*ix, warp)));
            iyy = sum(sum(imwarp(iy.*iy, warp)));
            ixy = sum(sum(imwarp(ix.*iy, warp)));

            BtB = [ixx, ixy;
                   ixy, iyy];


            B_it = [sum(sum(ix.*it));
                    sum(sum(iy.*it))];

            delta_p = -inv(BtB)*B_it;

            p = p + delta_p;
        end

        clearvars warp;
        %         Next iteration should be on an image twice the size
        p = p.*2;
    end

    u = p(1);
    v = p(2);
end
