function runme

    inputVideo = vision.VideoFileReader(fullfile('..', 'INPUT','input.avi'));
    outputVideo = vision.VideoFileWriter(fullfile('..', 'OUTPUT','stabilized.avi'), ...
        'FrameRate', inputVideo.info.VideoFrameRate, 'Quality', 50, 'VideoCompressor', 'MJPEG Compressor');

    %     Video stabilization
    stabilizeVideo(inputVideo, outputVideo);

    release(inputVideo);
    release(outputVideo);

end
