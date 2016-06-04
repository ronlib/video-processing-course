function trackCharacter(hObject, handles, inputVideoPath)
    
    % SET NUMBER OF PARTICLES
    N = 100;
    inputVideo = vision.VideoFileReader(inputVideoPath);
    outputVideoPath = fullfile(pwd, '..', '..', 'OUTPUT','OUTPUT.avi');
    outputVideo = vision.VideoFileWriter(outputVideoPath, 'FrameRate', ...
        inputVideo.info.VideoFrameRate, 'Quality', 75, 'VideoCompressor', 'MJPEG Compressor');
    firstFrame = step(inputVideo);
    axes(handles.axes1);
    set(handles.axes1, 'SortMethod', 'childorder');
    imshow(firstFrame);
    % Initial Settings
    printMessage(handles, sprintf('Select the object by marking a rectangle and double clicking it\n'));
    rect = imrect();
    rect.wait();
    position = num2cell(rect.getPosition());
    [x, y, xWidth, yHeight] = deal(position{:});
    rect.delete();
    
    s_initial = [0  % x center
        0     % y center
        0     % half width
        0     % half height
        0      % velocity x
        0   ]; % velocity y
    
    [middleX, middleY, halfWidth, halfHeight] = sanitizePosition(size(firstFrame), x, y, xWidth, yHeight);
    s_initial(1:4) = [middleX, middleY, halfWidth, halfHeight];

    % CREATE INITIAL PARTICLE MATRIX 'S' (SIZE 6xN)
    S = predictParticles(repmat(s_initial, 1, N));

    % LOAD FIRST IMAGE
    I = firstFrame;
    S = filterParticles(I, S);

    % COMPUTE NORMALIZED HISTOGRAM
    q = compNormHist(I,s_initial);

    % COMPUTE NORMALIZED WEIGHTS (W) AND PREDICTOR CDFS (C)
    % YOU NEED TO FILL THIS PART WITH CODE LINES:
    [C,W] = compute_weight_cdf(q,S,I);

    %% MAIN TRACKING LOOP
    counter = 1;
    while ~isDone(inputVideo)
        S_prev = S;
        % LOAD NEW IMAGE FRAME
        I = step(inputVideo);

        % SAMPLE THE CURRENT PARTICLE FILTERS
        S_next_tag = sampleParticles(S_prev,C);

        % PREDICT THE NEXT PARTICLE FILTERS (YOU MAY ADD NOISE)    
        S_next = predictParticles(S_next_tag);
        S_next = filterParticles(I, S_next);

        % COMPUTE NORMALIZED WEIGHTS (W) AND PREDICTOR CDFS (C)
        % YOU NEED TO FILL THIS PART WITH CODE LINES:
        [C,W] = compute_weight_cdf(q,S_next,I);

        % SAMPLE NEW PARTICLES FROM THE NEW CDF'S
        S = sampleParticles(S_next,C);

        % CREATE DETECTOR PLOTS
        showParticles(handles, I,S_next,W);
        plottedFrame = getframe(handles.axes1);
        plottedFrame = plottedFrame.cdata;
        step(outputVideo, plottedFrame);
        printMessage(handles, sprintf('Processing frame #%d', counter));
        counter = counter + 1;
    end
    release(outputVideo);
    setVideoDisplay(hObject, handles, outputVideoPath);
end

function [middleX, middleY, halfWidth, halfHeight] = sanitizePosition(imageSize, x, y, width, height)
    if x < 1
        x = 1;
    end
    
    if x+width < 1
       ME = MException('X is out of bounds');
       throw(ME);
    end
    
    if x > imageSize(2)
       ME = MException('X is out of bounds');
       throw(ME);
    end
    
    if x+width > imageSize(2)
        width = imageSize(2)-x;
    end
    
    
    if y < 1
        y = 1;
    end
    
    if y+height < 1
       ME = MEyception('Y is out of bounds');
       throw(ME);
    end
    
    if y > imageSize(1)
       ME = MEyception('Y is out of bounds');
       throw(ME);
    end
    
    if y+height > imageSize(1)
        height = imageSize(1)-y;
    end
    
%    [middleX, middleY, halfWidth, halfHeight]
    middleX = round(x+width/2);
    middleY = round(y+height/2);
    
    halfWidth = round(width/2);
    halfHeight = round(height/2);
    
end