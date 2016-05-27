function runme

    inputVideo = vision.VideoFileReader(fullfile('..', 'INPUT','input.avi'));
    outputVideo = vision.VideoFileWriter(fullfile('..', 'OUTPUT','stabilized.avi'), ...
        'FrameRate', inputVideo.info.VideoFrameRate, 'Quality', 50, 'VideoCompressor', 'MJPEG Compressor');

    %     Video stabilization
    %     stabilizeVideo(inputVideo, outputVideo);
    
%     Get foreground points from the first frame
    inputVideo.reset();
    firstFrame = step(inputVideo);
    grayFirstFrame = rgb2hsv(firstFrame);
    grayFirstFrame = grayFirstFrame(:,:,3);
    
    f = figure();
    imshow(firstFrame);
    
%     Choose background
    % TODO: write text to user differently when GUI is available
    fprintf('Enter foreground points\n');
    [x, y] = getpts(f);
    foregroundPts = round([x,y]);
    foregroundSamples = grayFirstFrame(sub2ind(size(grayFirstFrame), foregroundPts(:,2), foregroundPts(:,1)));
    foregroundSeedMask = zeros(size(grayFirstFrame));
    foregroundSeedMask(sub2ind(size(grayFirstFrame), foregroundPts(:,2), foregroundPts(:,1))) = 1;
    
    [bandwidth,foregroundDensity,xmesh,cdf] = kde(foregroundSamples,1024,0,1);
    foregroundImageHistMatch = calcHistMatchForImage(grayFirstFrame, foregroundDensity, xmesh);
    
    fprintf('Enter background points\n');
    [x, y] = getpts(f);
    backgroundPts = round([x,y]);
    backgroundSamples = grayFirstFrame(sub2ind(size(grayFirstFrame), backgroundPts(:,2), backgroundPts(:,1)));
    backgroundSeedMask = zeros(size(grayFirstFrame));
    backgroundSeedMask(sub2ind(size(grayFirstFrame), backgroundPts(:,2), backgroundPts(:,1))) = 1;
    
    [bandwidth,backgroundDensity,xmesh,cdf] = kde(backgroundSamples,1024,0,1);
    backgroundImageHistMatch = calcHistMatchForImage(grayFirstFrame, backgroundDensity, xmesh);
    
    epsilon = 0.01;
    
    pForeground = foregroundImageHistMatch./(foregroundImageHistMatch + backgroundImageHistMatch + epsilon);
    pBackground = backgroundImageHistMatch./(foregroundImageHistMatch + backgroundImageHistMatch + epsilon);
    
    foregroundGraydist = graydist(pForeground, boolean(foregroundSeedMask));
    backgroundGraydist = graydist(pBackground, boolean(backgroundSeedMask));


    release(inputVideo);
    release(outputVideo);

end


function [imageHistMatch]=calcHistMatchForImage(grayImage, density, xmesh)
    % This function calculates the probability for each pixle of the image,
    % based on its intensity, and according to a density vector
    
    imSize = size(grayImage);
    flattenedGrayFirstFrame = reshape(grayImage, [], 1);
    imageHistMatch = density(discretize(flattenedGrayFirstFrame, xmesh));
    imageHistMatch = reshape(imageHistMatch, imSize);
end
