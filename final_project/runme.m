function runme
    inputVideo = vision.VideoFileReader(fullfile('INPUT','input.avi'));
    outputVideo = vision.VideoFileWriter(fullfile('OUTPUT','stabilized.avi'), ...
        'FrameRate', inputVideo.info.VideoFrameRate, 'Quality', 50);
    outputVideo.VideoCompressor = 'MJPEG Compressor';

    stabilizeVideo(inputVideo, outputVideo);

    release(inputVideo);
    release(outputVideo);


%
%     % TODO: remove
%     for i=[1,60]
%         secondFrame = rgb2gray(step(inputVideo));
%     end
%
%     [T, status] = findImagesTransformation(firstFrame, secondFrame);



end
