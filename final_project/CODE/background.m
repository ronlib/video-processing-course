function [backgroundImg] = background(InputVid,nFrames,display)%,k,thresh,Display )

%initial parameters
MAxNumOfFrames = 2*256;
gray=0;

% %Load video file
% InputVid = vision.VideoFileReader(InputVidName, ...
%                                       'ImageColorSpace', 'RGB',...
%                                       'VideoOutputDataType', 'uint8');
% obj = VideoReader(InputVidName); 
% lastFrame = read(obj, inf);
% %nFrames = round(obj.FrameRate*obj.CurrentTime);
% nFrames = obj.NumberOfFrames;
% %nFrames = VideoReader(InputVidName).NumberOfFrames; 

frame = step(InputVid);
[h,w,~] = size(frame);
if (gray)
    [xx,yy] = meshgrid(1:w,1:h);
else
    [xx,yy,zz]=meshgrid(1:w,1:h,1:3);
end

%initialize video histogram
if (gray)
    videoHist = zeros(size(frame,1),size(frame,2),256,'uint8');
else        
    videoHist = zeros(size(frame,1),size(frame,2),3,256,'uint8');    
end

k=1;

simpleMedian = frame;

%h_Bar = waitbar(0,{'Video Background Subtraction...',['Frame ',num2str(k),' out of ',num2str(nFrames)]});
h_bar = waitbar(0,'1','Name','Video Background Subtraction...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');

while (~isDone(InputVid) && k <= MAxNumOfFrames)     

    waitbar(k/nFrames,h_bar,{'Video Background Subtraction...',['Frame ',num2str(k),' out of ',num2str(nFrames)]});    
    
    inxd = find((simpleMedian > frame));
    simpleMedian(inxd) = simpleMedian(inxd)-1;

    inxu = find(simpleMedian(:,:,:) < frame(:,:,:));
    simpleMedian(inxu) = simpleMedian(inxu)+1;          
    
    %update video histogram
    if (gray)        
        frame_g = rgb2gray(frame);
        inx = sub2ind(size(videoHist),yy(:),xx(:),frame_g(:)+1);
    else        
        inx = sub2ind(size(videoHist),yy(:),xx(:),zz(:),double(frame(:)+1));                
    end
    
    videoHist(inx) = videoHist(inx) + 1;   
    
    %videoHist(:,:,frame(:,:,1)+1) = videoHist(:,:,frame(:,:,1)+1) + 1;        
    frame = step(InputVid);  
    k = k+1;
    
%     if( mod(k,10) == 0)

%     end
    
end

delete(h_bar);
release(InputVid);

if (gray)
    videoMedian2 = zeros(h,w,'uint8');
    [~,videoMedian2(:,:)] = max(videoHist,[],3);
else
    videoMedian2 = zeros(h,w,3,'uint8');
    [~,videoMedian2(:,:,:)] = max(videoHist,[],4);
end

videoMedian2= videoMedian2 - 1;

if(display)
    figure; subplot(2,2,1);
    title({'last frame'});
    imshow(frame);
    subplot(2,2,2);
    title({'median image'});
    imshow(simpleMedian);
    subplot(2,2,3);
    title({'median image 2'});
    imshow(videoMedian2);
    
    figure;
    imshow(videoMedian2);
    
    imwrite(videoMedian2,'backgroundImg.png');
end

backgroundImg = videoMedian2;

end

