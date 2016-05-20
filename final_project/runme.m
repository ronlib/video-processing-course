function runme
    inputVideo = VideoReader(fullfile('INPUT','input2.avi'));
    
    firstFrame = rgb2gray(inputVideo.readFrame());
    
    % TODO: remove
    secondFrame = rgb2gray(inputVideo.readFrame());
    
    T = findImagesTransformation(firstFrame, secondFrame);
        

end