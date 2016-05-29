function trackCharacter(hObject, handles, inputVideoPath)
    
    % SET NUMBER OF PARTICLES
    N = 100;
    inputVideo = vision.VideoFileReader(inputVideoPath);
    firstFrame = step(inputVideo);
    axes(handles.axes1);
    imshow(firstFrame);
    % Initial Settings
    % Using fullfile in order to support Matlab under Linux
    printMessage(handles, sprintf('Select the object by selecting a rectangle and double clicking it\n'));
    rect = imrect();
    rect.wait();
    [x, y, xWidth, yHeight] = rect.getPosition();
    rect.delete();
    
    s_initial = [297   % x center
        139    % y center
        16     % half width
        43     % half height
        0      % velocity x
        0   ]; % velocity y
    
    s_initial(1:4) = sanitizePosition(x, y, xWidth, yHeight);

    % CREATE INITIAL PARTICLE MATRIX 'S' (SIZE 6xN)
    S = predictParticles(repmat(s_initial, 1, N));

    % LOAD FIRST IMAGE
    I = imread([fullfile('Images', images(1).name)]);
    S = filterParticles(I, S);

    % COMPUTE NORMALIZED HISTOGRAM
    q = compNormHist(I,s_initial);

    % COMPUTE NORMALIZED WEIGHTS (W) AND PREDICTOR CDFS (C)
    % YOU NEED TO FILL THIS PART WITH CODE LINES:
    [C,W] = compute_weight_cdf(q,S,I);

    %% MAIN TRACKING LOOP

    for i=2:length(images)
        S_prev = S;
        % LOAD NEW IMAGE FRAME
        I = imread([fullfile('Images', images(i).name)]);

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
        if (mod(i,10)==0)
            showParticles(I,S,W,i,'GROUP-04-02');
        end
    end
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
    middleX = round((x+width)/2);
    middleY = round((y+height)/2);
    
    halfWidth = round(width/2);
    halfHeight = round(height/2);
    
end