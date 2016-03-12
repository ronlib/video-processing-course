function main
%     Q2A_GROUP_4_2('atrium.avi');
%     Q2B_GROUP_4_2('atrium.avi');
%     Q2C_GROUP_4_2('atrium.avi');
    Q2D_GROUP_4_2('atrium.avi');
end

function Q2A_GROUP_4_2(filename)
    inputVid = VideoReader(filename);
    outputVidLossy = VideoWriter('Vid1.avi');
    outputVidLossy.Quality = 75;
    outputVidLossy.FrameRate = inputVid.framerate;
    open(outputVidLossy);
    
    while hasFrame(inputVid)
        tempFrame = readFrame(inputVid);
        % insert your editing here
        bwthresh = graythresh(tempFrame);
        tempFrame = uint8(im2bw(tempFrame, bwthresh))*intmax('uint8he');
        % save edited video
        writeVideo(outputVidLossy,tempFrame);
    end
    close(outputVidLossy);
end

function Q2B_GROUP_4_2(filename)
    inputVid = VideoReader(filename);
    outputVidLossy = VideoWriter('Vid2.avi');
    outputVidLossy.Quality = 75;
    outputVidLossy.FrameRate = inputVid.framerate;
    open(outputVidLossy);
    
    while hasFrame(inputVid)
        tempFrame = readFrame(inputVid);
        % insert your editing here
        bwthresh = g(tempFrame);
        tempFrame = imcomplement(uint8(im2bw(tempFrame, bwthresh))*intmax('uint8'));
        % save edited video
        writeVideo(outputVidLossy,tempFrame);
    end
    close(outputVidLossy);
end

function Q2C_GROUP_4_2(filename)
    inputVid = VideoReader(filename);
    outputVidLossy = VideoWriter('Vid3.avi');
    outputVidLossy.Quality = 75;
    outputVidLossy.FrameRate = inputVid.framerate;
    open(outputVidLossy);
    
    while hasFrame(inputVid)
        tempFrame = readFrame(inputVid);
        grayFrame = rgb2gray(tempFrame);

        sobel_x =   [-1 0 1;
                     -2 0 2;
                     -1 0 1];
        sobel_y = sobel_x';

        temp_sobel_x = conv2(grayFrame, sobel_x, 'same');
        temp_sobel_y = conv2(grayFrame, sobel_y, 'same');

        sobel_edge = sqrt(temp_sobel_x.^2 + temp_sobel_y.^2);
        sobel_edge = sobel_edge/max(max(sobel_edge));
        thresh = graythresh(sobel_edge);
        edges = uint8(im2bw(sobel_edge, thresh))*uint8(intmax('uint8'));
        reverseEdgesBin = imcomplement(edges)/255;

        outputFrame = cat(3, ...
            max(tempFrame(:, :, 1), edges), ...
            tempFrame(:, :, 2).*reverseEdgesBin, ...
            tempFrame(:, :, 3).*reverseEdgesBin);

        % save edited video
        writeVideo(outputVidLossy, outputFrame);
    end
    close(outputVidLossy);
end

function Q2D_GROUP_4_2(filename)
    inputVid = VideoReader(filename);
    outputVidLossy = VideoWriter('Vid4.avi');
    outputVidLossy.Quality = 75;
    outputVidLossy.FrameRate = inputVid.framerate;
    open(outputVidLossy);
    
    while hasFrame(inputVid)
        tempFrame = readFrame(inputVid);
        grayFrame = rgb2gray(tempFrame);    

        sobel_edge = edge(grayFrame, 'sobel');
        reverseEdgesBin = uint8(imcomplement(sobel_edge));

        outputFrame = cat(3, ...
            max(tempFrame(:, :, 1), uint8(sobel_edge)*intmax('uint8')), ...
            tempFrame(:, :, 2).*reverseEdgesBin, ...
            tempFrame(:, :, 3).*reverseEdgesBin);

        % save edited video
        writeVideo(outputVidLossy, outputFrame);
    end
    close(outputVidLossy);
end