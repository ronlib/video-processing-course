function videoMatting(hObject, handles, backgroundImagePath)
    
    binaryVideoPath = fullfile(pwd, '..', '..', 'OUTPUT', 'binary.avi');
    binaryVideo = vision.VideoFileReader(binaryVideoPath);
    extractedCharacterVideoPath = fullfile(pwd, '..', '..', 'OUTPUT', 'extracted.avi');
    extractedCharacterVideo = vision.VideoFileReader(extractedCharacterVideoPath);
    backgroundImage = im2double(imread(backgroundImagePath));
    outputMattedVideoPath = fullfile(pwd, '..', '..', 'OUTPUT','matted.avi');
    outputMattedVideo = vision.VideoFileWriter(fullfile(pwd, '..', '..', 'OUTPUT','matted.avi'), ...
        'FrameRate', binaryVideo.info.VideoFrameRate, 'Quality', 75, 'VideoCompressor', 'MJPEG Compressor');
    
    tempFrame = step(extractedCharacterVideo);
    % Handle the case where the background is gray and the video is colored
    if size(tempFrame, 3) > 1 && size(backgroundImage, 3) == 1
        backgroundImage = repmat(backgroundImage, 1, 1, 3);
    end
    imageSize = size(tempFrame);
    backgroundImage = imresize(backgroundImage, imageSize(1:2));
    extractedCharacterVideo.reset();    
    
    counter = 1;
    while ~isDone(extractedCharacterVideo)
        printMessage(handles, sprintf('Working on frame #%d\n', counter));
        extractedFrame = im2double(step(extractedCharacterVideo));
        binaryFrame = step(binaryVideo);
%         if shouldRepmatVideo
%             extractedFrame = repmat(extractedFrame, 1, 1, 3);
%             binaryFrame = repmat(binaryFrame, 1, 1, 3);
%         end
        outputFrame = (1-binaryFrame).*backgroundImage + binaryFrame.*extractedFrame;
        step(outputMattedVideo, outputFrame);        
        counter = counter + 1;
    end
    
    release(outputMattedVideo);
    release(extractedCharacterVideo);
    release(binaryVideo);
    
    setVideoDisplay(hObject, handles, outputMattedVideoPath);
    
end