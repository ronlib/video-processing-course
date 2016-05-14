function ResizeVideo (input_file_path, output_file_path)
    inputVid = VideoReader(input_file_path);
%     outputVid = 	(output_file_path);    
%     outputVid.Quality = inputVid.Quality;
    outputVid.FrameRate = inputVid.FrameRate;
    
    open(outputVid);
    while hasFrame(inputVid)
        tempFrame = imresize(readFrame(inputVid), 0.25);
        writeVideo(outputVid, tempFrame);
    end
    close(outputVid);
end
