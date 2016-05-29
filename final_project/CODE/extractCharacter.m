function extractCharacter(handles)

    %     Video stabilization
%     stabilizeVideo(inputVideo, outputVideo);      
    release(outputVideo);
%     release(inputVideo);
%     close(inputVideo);
    
    inputVideo = vision.VideoFileReader(fullfile(pwd, '..', '..', 'INPUT','stabilized_rect.avi'));
    outputVideo = vision.VideoFileWriter(fullfile(pwd, '..', '..', 'OUTPUT','binary.avi'), ...
        'FrameRate', inputVideo.info.VideoFrameRate, 'Quality', 50, 'VideoCompressor', 'MJPEG Compressor');
    backgroundImage = imread('/home/ron/studies/video-processing-course/final_project/INPUT/background.jpg');
    grayBackgroundImage = single(rgb2gray(imresize(backgroundImage, 0.25)))/256;

    firstFrame = step(inputVideo);
    grayFirstFrame = rgb2gray(firstFrame);
    counter = 1;
    while ~isDone(inputVideo) && counter < 100

        curFrame = rgb2gray(step(inputVideo));
        [foregroundScribblePoints, backgroundScribblePoints]=findScribblePoints(grayBackgroundImage, curFrame);
        
        
        foregroundSeedMask = zeros(size(grayFirstFrame));
        foregroundSeedMask(foregroundScribblePoints) = 1;
        foregroundSamples = curFrame(foregroundScribblePoints);
        
        backgroundSeedMask = zeros(size(grayFirstFrame));
        backgroundSeedMask(backgroundScribblePoints) = 1;
        backgroundSamples = curFrame(backgroundScribblePoints);
        
        [bandwidth,foregroundDensity,xmesh,cdf] = kde(foregroundSamples,2048,0,1);
        foregroundImageHistMatch = calcHistMatchForImage(curFrame, foregroundDensity, xmesh);
 
        [bandwidth,backgroundDensity,xmesh,cdf] = kde(backgroundSamples,2048,0,1);
        backgroundImageHistMatch = calcHistMatchForImage(curFrame, backgroundDensity, xmesh);
        
        epsilon = 0.01;
    
        pForeground = foregroundImageHistMatch./(foregroundImageHistMatch + backgroundImageHistMatch + epsilon);
        pBackground = backgroundImageHistMatch./(foregroundImageHistMatch + backgroundImageHistMatch + epsilon);

        [pForegroundGmag, pForegroundGdir] = imgradient(pForeground);
        [pBackgroundGmag, pBackgroundGdir] = imgradient(pBackground);
        foregroundGraydist = graydist(pForegroundGmag, boolean(foregroundSeedMask));
        backgroundGraydist = graydist(pBackgroundGmag, boolean(backgroundSeedMask));
        showImage(handles, foregroundGraydist<backgroundGraydist);
        step(outputVideo, foregroundGraydist<backgroundGraydist);
        printMessage(handles, sprintf('Working on frame #%d\n', counter));
        if counter == 55
            fprintf('time to stop\n');
        end
        counter = counter + 1;
    end
    
    release(outputVideo);
    
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
    
    fprintf('Enter background points\n');
    [x, y] = getpts(f);
    backgroundPts = round([x,y]);
    backgroundSamples = grayFirstFrame(sub2ind(size(grayFirstFrame), backgroundPts(:,2), backgroundPts(:,1)));
    backgroundSeedMask = zeros(size(grayFirstFrame));
    backgroundSeedMask(sub2ind(size(grayFirstFrame), backgroundPts(:,2), backgroundPts(:,1))) = 1;
    
    
    [bandwidth,foregroundDensity,xmesh,cdf] = kde(foregroundSamples,2048,0,1);
    foregroundImageHistMatch = calcHistMatchForImage(grayFirstFrame, foregroundDensity, xmesh);
    
    [bandwidth,backgroundDensity,xmesh,cdf] = kde(backgroundSamples,2048,0,1);
    backgroundImageHistMatch = calcHistMatchForImage(grayFirstFrame, backgroundDensity, xmesh);
    
    epsilon = 0.01;
    
    pForeground = foregroundImageHistMatch./(foregroundImageHistMatch + backgroundImageHistMatch + epsilon);
    pBackground = backgroundImageHistMatch./(foregroundImageHistMatch + backgroundImageHistMatch + epsilon);
    
    [pForegroundGmag, pForegroundGdir] = imgradient(pForeground);
    [pBackgroundGmag, pBackgroundGdir] = imgradient(pBackground);
    foregroundGraydist = graydist(pForegroundGmag, boolean(foregroundSeedMask));
    backgroundGraydist = graydist(pBackgroundGmag, boolean(backgroundSeedMask));


    release(inputVideo);
end


function [imageHistMatch]=calcHistMatchForImage(grayImage, density, xmesh)
    % This function calculates the probability for each pixle of the image,
    % based on its intensity, and according to a density vector
    
    imSize = size(grayImage);
    flattenedGrayFirstFrame = reshape(grayImage, [], 1);
    imageHistMatch = density(discretize(flattenedGrayFirstFrame, xmesh))./max(density(:));
    imageHistMatch = reshape(imageHistMatch, imSize);
end


function [foregroundScribblePoints, backgroundScribblePoints]=findScribblePoints(grayBackground, grayFrame)
    diffImage = abs(grayFrame - grayBackground);
    % TODO: change the filter size to resemble a human
    estimatedObjLength = round(max(size(grayFrame))*0.07);
    estimatedObjSize = round([estimatedObjLength, estimatedObjLength*0.6]);
    bigDiffImage = imfilter(diffImage, fspecial('gaussian', estimatedObjSize, estimatedObjLength*0.7));
    bigDiffImage = bigDiffImage./max(bigDiffImage(:));
    
    foregroundScribblePoints = find(bigDiffImage>0.9);
    backgroundScribblePoints = find(bigDiffImage<0.15);
    
end