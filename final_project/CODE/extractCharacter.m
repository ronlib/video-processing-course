function extractCharacter(handles, inputVideoPath)

%     inputVideo = vision.VideoFileReader(fullfile(pwd, '..', '..', 'INPUT','stabilized_rect.avi'));
    inputVideo = vision.VideoFileReader(inputVideoPath);
    outputBinaryVideo = vision.VideoFileWriter(fullfile(pwd, '..', 'OUTPUT','binary.avi'), ...
        'FrameRate', inputVideo.info.VideoFrameRate, 'Quality', 75, 'VideoCompressor', 'MJPEG Compressor');
    outputExtractedVideo = vision.VideoFileWriter(fullfile(pwd, '..', 'OUTPUT','extracted.avi'), ...
        'FrameRate', inputVideo.info.VideoFrameRate, 'Quality', 75, 'VideoCompressor', 'MJPEG Compressor');
    backgroundImage = imread('/home/ron/studies/Video_processing/final_project/INPUT/background.jpg');
    grayBackgroundImage = single(rgb2gray(imresize(backgroundImage, 0.25)))/256;

    firstFrame = step(inputVideo);
    grayFirstFrame = rgb2gray(firstFrame);
    counter = 1;
    while ~isDone(inputVideo)
        curFrame = step(inputVideo);
        grayCurFrame = rgb2gray(curFrame);
        [foregroundScribblePoints, backgroundScribblePoints]=findScribblePoints(grayBackgroundImage, grayCurFrame);
        
        
        foregroundSeedMask = zeros(size(grayFirstFrame));
        foregroundSeedMask(foregroundScribblePoints) = 1;
        foregroundSamples = grayCurFrame(foregroundScribblePoints);
        
        backgroundSeedMask = zeros(size(grayFirstFrame));
        backgroundSeedMask(backgroundScribblePoints) = 1;
        backgroundSamples = grayCurFrame(backgroundScribblePoints);
        
        [bandwidth,foregroundDensity,xmesh,cdf] = kde(foregroundSamples,2048,0,1);
        foregroundImageHistMatch = calcHistMatchForImage(grayCurFrame, foregroundDensity, xmesh);
 
        [bandwidth,backgroundDensity,xmesh,cdf] = kde(backgroundSamples,2048,0,1);
        backgroundImageHistMatch = calcHistMatchForImage(grayCurFrame, backgroundDensity, xmesh);
        
        epsilon = 0.01;
    
        pForeground = foregroundImageHistMatch./(foregroundImageHistMatch + backgroundImageHistMatch + epsilon);
        pBackground = backgroundImageHistMatch./(foregroundImageHistMatch + backgroundImageHistMatch + epsilon);

        [pForegroundGmag, ~] = imgradient(pForeground);
        [pBackgroundGmag, ~] = imgradient(pBackground);
        foregroundGraydist = graydist(pForegroundGmag, boolean(foregroundSeedMask));
        backgroundGraydist = graydist(pBackgroundGmag, boolean(backgroundSeedMask));
        showImage(handles, foregroundGraydist<backgroundGraydist);
        step(outputBinaryVideo, foregroundGraydist<backgroundGraydist);
        step(outputExtractedVideo, curFrame.*repmat(foregroundGraydist<backgroundGraydist, 1, 1, size(curFrame, 3)));
        printMessage(handles, sprintf('Working on frame #%d\n', counter));
        counter = counter + 1;
    end
    
    release(outputBinaryVideo);
    release(outputExtractedVideo);
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