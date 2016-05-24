function ResizeVideo (input_file_path, output_file_path)
    inputVid = VideoReader(input_file_path);
    outputVid = vision.VideoFileWriter(output_file_path, 'FrameRate', inputVid.FrameRate, 'Quality', 50);
    outputVid.VideoCompressor = 'MJPEG Compressor';

    rectangleCounter = 0;
%     firstFrame = imresize(readFrame(inputVid), 0.5);
    firstFrame = readFrame(inputVid);
    while hasFrame(inputVid) && rectangleCounter < 300
        currentFrame = firstFrame;

        tempFrame = insertShape(currentFrame, 'FilledRectangle', [rectangleCounter, 150, 40, 100], 'Color', 'black', 'Opacity', 1);
        rectangleCounter = rectangleCounter+1;
        step(outputVid, tempFrame);
    end
    release(outputVid);
%     close(inputVid);
end
