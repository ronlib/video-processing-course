function stabilizeVideo(inputVideoPath, handles)
%     firstFrame = step(inputVideo);
    
    inputVideo = VideoReader(inputVideoPath);
    outputVideoPath = fullfile(pwd, '..', '..', 'OUTPUT','stabilized.avi');
    outputVideo = vision.VideoFileWriter(outputVideoPath, 'FrameRate', ...
        inputVideo.FrameRate, 'Quality', 75, 'VideoCompressor', 'MJPEG Compressor');

    firstFrame = inputVideo.readFrame();
    grayFirstFrame = rgb2gray(firstFrame);
    
%     outputVideo = vision.VideoFileWriter(outputVideo);

    inputFramesCounter = 0;
    while inputVideo.hasFrame()
        inputFramesCounter = inputFramesCounter + 1;
%         curFrame = step(inputVideo);
        curFrame = inputVideo.readFrame();
        [T, status] = findImagesTransformation(grayFirstFrame, rgb2gray(curFrame));
        
        if status==0 % No error
            step(outputVideo, imwarp(curFrame, T, 'OutputView', imref2d(size(firstFrame))));                        
        else
            printMessage(handles, sprintf('skipped frame %d!\n', inputFramesCounter));
        end
        
        printMessage(handles, sprintf('Processed %d frames\n', inputFramesCounter));
    end
    
    release(outputVideo);
    close(inputVideo);
    printMessage(handles, sprintf('Stabilized video written to OUTPUT/stabilized.avi\n'));
end