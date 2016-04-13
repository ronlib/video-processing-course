function [u,v] = LucasKanadeOpticalFlow(I1, I2, WindowSize,MaxIter,NumLevels)

    i_resized = cell(1, NumLevels);
    i_resized{1, NumLevels} = I1;
    i_resized{2, NumLevels} = I2;

    for level = [1:NumLevels-1]
        i_resized{1, NumLevels-level} = impyramid(i_resized{1, NumLevels-level+1}, 'reduce');
        i_resized{2, NumLevels-level} = impyramid(i_resized{2, NumLevels-level+1}, 'reduce');
    end

    u = zeros(size(i_resized{1, 1}));
    v = zeros(size(i_resized{1, 1}));

    for level = [1:NumLevels]
        for loop = [1:MaxIter]

            warped_im = WarpImage(i_resized{2, level}, u, v);
            resized = i_resized{1, level};
            [du, dv] = LucasKanadeStep(resized ,warped_im , WindowSize);
            u = u + du;
            v = v + dv;

            clearvars du dv warp;

        end

        %  Next iteration should be on an image twice the size
        if level < NumLevels
            u = imresize(u, size(i_resized{2,level+1})).*2;
            v = imresize(v, size(i_resized{2,level+1})).*2;
        end

    end
end
