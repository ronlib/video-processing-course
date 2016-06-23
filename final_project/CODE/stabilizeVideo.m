function stabilizeVideo(hObject, handles, inputVideoPath)

    inputVideo = VideoReader(inputVideoPath);
    outputVideoPath = fullfile(pwd, '..', '..', 'OUTPUT','stabilized.avi');
    outputVideo = vision.VideoFileWriter(outputVideoPath, 'FrameRate', ...
        inputVideo.FrameRate, 'Quality', 75, 'VideoCompressor', 'MJPEG Compressor');

    firstFrame = inputVideo.readFrame();
    grayFirstFrame = rgb2gray(firstFrame);
    prevFrame = grayFirstFrame;
%     outputVideo = vision.VideoFileWriter(outputVideo);
    Tcumulative = projective2d();
    Tcumulative.T = eye(3);

    inputFramesCounter = 0;
    while inputVideo.hasFrame()
        inputFramesCounter = inputFramesCounter + 1;
%         curFrame = step(inputVideo);
        curFrame = inputVideo.readFrame();
        %[T, status] = findImagesTransformation(grayFirstFrame, rgb2gray(curFrame));
        [T, status] = findImagesTransformation(prevFrame, rgb2gray(curFrame));

        Tcumulative.T = T.T * Tcumulative.T;

        if status==0 % No error
            %step(outputVideo, imgB_RGB, Tcumulative);
            step(outputVideo, imwarp(curFrame, Tcumulative, 'OutputView', imref2d(size(firstFrame))));
        else
            printMessage(handles, sprintf('skipped frame %d!\n', inputFramesCounter));
        end

        prevFrame = rgb2gray(curFrame);

        printMessage(handles, sprintf('Processed %d frames\n', inputFramesCounter));
    end

    release(outputVideo);
%     close(inputVideo);
    printMessage(handles, sprintf('Stabilized video written to OUTPUT/stabilized.avi\n'));


    setVideoDisplay(hObject, handles, outputVideoPath);

end
