function OutputVid = LucasKanadeVideoStabilization(InputVid,WindowSize,MaxIter,NumLevels,NumOfFrames)

		OutputVidName = 'outputVid.avi';
		OutputVid = vision.VideoFileWriter(OutputVidName,'FrameRate',InputVid.info.VideoFrameRate);
		%OutputVid = vision.VideoFileWriter(OutputVidName);
		%outputVidLossy = VideoWriter('outputVid.avi');
		%outputVidLossy.Quality = 75;
		%outputVidLossy.FrameRate = InputVid.framerate;
		%open(outputVidLossy);
		k = 1;

		%firstFrame = step(InputVid);
		preFrame = step(InputVid);
		if(size(preFrame,3)>1)
				preFrame = rgb2gray(preFrame);
		end

		while (~isDone(InputVid) && k<=NumOfFrames)
				disp( ['frame number ',num2str(k)]);

				Frame = step(InputVid);

				if(size(Frame,3)>1)
						GrayFrame = rgb2gray(Frame);
				end

				[du,dv]=LucasKanadeOpticalFlow(preFrame,GrayFrame,WindowSize,MaxIter,NumLevels);
				if(k==1)
						 u = zeros(size(du));
						 v = zeros(size(dv));
				end
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
