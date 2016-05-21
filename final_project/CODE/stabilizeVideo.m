function stabilizeVideo(inputVideo, outputVideo)
    firstFrame = step(inputVideo);
    grayFirstFrame = rgb2gray(firstFrame);
    
%     outputVideo = vision.VideoFileWriter(outputVideo);

    inputFramesCounter = 0;
    while ~isDone(inputVideo)
        inputFramesCounter = inputFramesCounter + 1;
        curFrame = step(inputVideo);
        [T, status] = findImagesTransformation(grayFirstFrame, rgb2gray(curFrame));
        
        if status==0 % No error
            step(outputVideo, imwarp(curFrame, T, 'OutputView', imref2d(size(firstFrame))));                        
        else
            fprintf('skipped frame %d!\n', inputFramesCounter);
        end
        
        fprintf('Processed %d frames\n', inputFramesCounter);
    end
    

end