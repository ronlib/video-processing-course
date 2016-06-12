function extractCharacter(hObject, handles, inputVideoPath)

    tempVideo = VideoReader(inputVideoPath);
    numberOfFrames = tempVideo.Duration*tempVideo.FrameRate;
    inputVideo = vision.VideoFileReader(inputVideoPath, 'VideoOutputDataType', 'uint8');
    outputBinaryVideo = vision.VideoFileWriter(fullfile(pwd, '..', '..', 'OUTPUT','binary.avi'), ...
        'FrameRate', inputVideo.info.VideoFrameRate, 'Quality', 75, 'VideoCompressor', 'MJPEG Compressor');
    outputExtractedVideoPath = fullfile(pwd, '..', '..', 'OUTPUT','extracted.avi');
    outputExtractedVideo = vision.VideoFileWriter(outputExtractedVideoPath, 'FrameRate', inputVideo.info.VideoFrameRate, ...
        'Quality', 75, 'VideoCompressor', 'MJPEG Compressor');
%     backgroundImage = imread('/home/ron/studies/Video_processing/final_project/INPUT/background.jpg');

    r = 1;
    boarderThickness = round(max(inputVideo.info.VideoSize)*0.015);

    backgroundImage = background(handles, inputVideo, round(numberOfFrames), 1);
    reset(inputVideo);
    firstFrame = step(inputVideo);
    firstFrameSize = size(firstFrame);
    grayFirstFrame = rgb2gray(firstFrame);
    grayBackgroundImage = im2single(rgb2gray(imresize(backgroundImage, firstFrameSize(1:2))));
    counter = 1;
    while ~isDone(inputVideo)
        curFrame = im2single(step(inputVideo));
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
        
%         maxDistance = max(max(backgroundGraydist(:)), max(foregroundGraydist(:)));
        [boarderLine, ~] = imgradient(foregroundGraydist<backgroundGraydist);

        % Widen the boarder line
        widenedTwiceBoaderline = imfilter(boarderLine, ones(boarderThickness*2))>0;
        widenedBoaderline = imfilter(boarderLine, ones(boarderThickness))>0;
        foregroundScribbles = (foregroundGraydist<backgroundGraydist).*(widenedTwiceBoaderline - widenedBoaderline);
        backgroundScribbles = (foregroundGraydist>backgroundGraydist).*(widenedTwiceBoaderline - widenedBoaderline);

        foregroundNearBoarderSamples = grayCurFrame(foregroundScribbles > 0);
        backgroundNearBoarderSamples = grayCurFrame(backgroundScribbles > 0);

        [~,foregroundBoarderDensity,xmesh,~] = kde(foregroundNearBoarderSamples,2048,0,1);
        foregroundBoarderDensity(foregroundBoarderDensity<0) = 0;
        foregroundImageBoarderHistMatch = calcHistMatchForImage(grayCurFrame, foregroundBoarderDensity, xmesh);

        [~,backgroundBoarderDensity,xmesh,~] = kde(backgroundNearBoarderSamples,2048,0,1);
        backgroundBoarderDensity(backgroundBoarderDensity<0) = 0;
        backgroundImageBoarderHistMatch = calcHistMatchForImage(grayCurFrame, backgroundBoarderDensity, xmesh);

        pForegroundBoarder = foregroundImageBoarderHistMatch./(foregroundImageBoarderHistMatch + backgroundImageBoarderHistMatch + epsilon);
        pBackgroundBoarder = backgroundImageBoarderHistMatch./(foregroundImageBoarderHistMatch + backgroundImageBoarderHistMatch + epsilon);

        [pForegroundGmag, ~] = imgradient(pForegroundBoarder);
        [pBackgroundGmag, ~] = imgradient(pBackgroundBoarder);

        foregroundBoarderGraydist = graydist(pForegroundGmag, foregroundScribbles > 0);
        backgroundBoarderGraydist = graydist(pBackgroundGmag, backgroundScribbles > 0);

        weightF = ((foregroundBoarderGraydist+epsilon).^-r) .* pForegroundBoarder;
        weightB = ((backgroundBoarderGraydist+epsilon).^-r) .* pBackgroundBoarder;

        alpha = widenedBoaderline.*(weightF./(weightF+weightB+epsilon)) + (1-widenedBoaderline).*(foregroundGraydist<backgroundGraydist);
        showImage(handles, foregroundGraydist<backgroundGraydist);
        step(outputBinaryVideo, alpha);
        step(outputExtractedVideo, curFrame.*repmat(alpha, 1, 1, size(curFrame, 3)));
        printMessage(handles, sprintf('Working on frame #%d/%d\n', counter, numberOfFrames));
        counter = counter + 1;
    end

    release(outputBinaryVideo);
    release(outputExtractedVideo);
    release(inputVideo);

    setVideoDisplay(hObject, handles, outputExtractedVideoPath);
end


function [imageHistMatch]=calcHistMatchForImage(grayImage, density, xmesh)
    % This function calculates the probability for each pixle of the image,
    % based on its intensity, and according to a density vector

    imSize = size(grayImage);
    flattenedGrayFrame = reshape(grayImage, [], 1);
    [~,~,bin] = histcounts(flattenedGrayFrame, xmesh);
    imageHistMatch = density(bin)./max(density(:));
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
