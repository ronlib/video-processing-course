function OutputVid = LucasKanadeVideoStabilization(InputVid,WindowSize,MaxIter,NumLevels,NumOfFrames)

    OutputVidName = 'StabilizedVid.avi';
    OutputVid = vision.VideoFileWriter(OutputVidName,'FrameRate',InputVid.info.VideoFrameRate);

    k = 1;       

    preFrame = step(InputVid);
    if(size(preFrame,3)>1)            
        preFrame = rgb2gray(preFrame);
    end

    u = zeros(size(preFrame));
    v = zeros(size(preFrame));              

    while (~isDone(InputVid) && k<=NumOfFrames)
        disp( ['frame number ',num2str(k)]);

        Frame = step(InputVid);

        if(size(Frame,3)>1)
                GrayFrame = rgb2gray(Frame);                                
        else 
                GrayFrame = Frame;
        end

        [du,dv]=LucasKanadeOpticalFlow(preFrame,GrayFrame,WindowSize,MaxIter,NumLevels);

        u = u + du;
        v = v + dv;
        
        wrapedFrame = WarpImage(GrayFrame,u,v);

        step(OutputVid, wrapedFrame);

        preFrame = GrayFrame;
        k=k+1;
    end

    release(InputVid);
    release(OutputVid);

end
