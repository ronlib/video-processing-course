function [backgroundImg] = background(handles, InputVid, nFrames, display)%,k,thresh,Display )

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

if(nFrames > MAxNumOfFrames)
%     errordlg('Video Background Subtraction was aborted - expectint less than 512 frames');  end;
    printMessage(handles, 'Video Background Subtraction was aborted - expectint less than 512 frames');  end;

frame = step(InputVid);
[H,W,C] = size(frame);

if(C~=3)
%     errordlg('Video Background Subtraction was aborted - expect RGB video');  end;
    printMessage(handles, 'Video Background Subtraction was aborted - expect RGB video');  end;

if (gray)
    [xx,yy] = meshgrid(1:W,1:H);
else
    [xx,yy,zz]=meshgrid(1:W,1:H,1:3);
end

%initialize video histogram
if (gray)
    videoHist = zeros(H,W,256,'uint8');
else        
    videoHist = zeros(H,W,3,256,'uint8');    
end

k=1;

%simpleMedian = frame;

% h_bar = waitbar(0,'1','Name','Video Background Subtraction...',...
%             'CreateCancelBtn',...
%             'setappdata(gcbf,''canceling'',1)');

%% Histogram creation        
while (~isDone(InputVid) && k <= MAxNumOfFrames && k <= nFrames)     

%     waitbar(k/nFrames,h_bar,{'Video Background Subtraction...Creating Histogram',['Frame ',num2str(k),' out of ',num2str(nFrames)]});    
    printMessage(handles, sprintf('Video Background Subtraction, creating Histogram. Frame #%d/%d', k, nFrames));
%     if (getappdata(h_bar,'canceling'))
%             errordlg('Video Background Subtraction was aborted by the user');            
%             delete(h_bar);return;
%     end        
%     inxd = find((simpleMedian > frame));
%     simpleMedian(inxd) = simpleMedian(inxd)-1;
%     inxu = find(simpleMedian(:,:,:) < frame(:,:,:));
%     simpleMedian(inxu) = simpleMedian(inxu)+1;          
    
    %update video histogram
    if (gray)        
        frame_g = rgb2gray(frame);
        inx = sub2ind(size(videoHist),yy(:),xx(:),frame_g(:)+1);
    else        
        inx = sub2ind(size(videoHist),yy(:),xx(:),zz(:),double(frame(:)+1));                
    end
    
    videoHist(round(inx)) = videoHist(round(inx)) + 1;
    
    % next frame
    frame = step(InputVid);  
    k = k+1;  
    
end

%delete(h_bar);
release(InputVid);

% if (gray)
%     videoMedian2 = zeros(H,W,'uint8');
%     [~,videoMedian2(:,:)] = max(videoHist,[],3);
% else
%     videoMedian2 = zeros(H,W,3,'uint8');
%     [~,videoMedian2(:,:,:)] = max(videoHist,[],4);
% end

%% extracting Median out of histogram
thresh = k/2;
videoMedian3 = zeros(size(frame),'uint8');
videoHistSum = cumsum(videoHist,4);

for row=1:H
%     waitbar(row/size(videoHist,1),h_bar,{'Video Background Subtraction...Median Extraction'});    
    printMessage(handles, sprintf('Median extraction, completed %f%%', 100*row/size(videoHist,1)));
%     if (getappdata(h_bar,'canceling'))
%             errordlg('Video Background Subtraction was aborted by the user');            
%             delete(h_bar);return;
    
%     end    
    for col=1:W
        for cha=1:C
%             fprintf('%d %d %d\n', row,col,cha);
            videoMedian3(row,col,cha) = find(videoHistSum(row,col,cha,:) >= thresh,1);
        end
    end
end

% delete(h_bar);
% videoMedian2= videoMedian2 - 1;

if(display)
%     figure; subplot(2,2,1);
%     title({'last frame'});
%     imshow(frame);
%     subplot(2,2,2);
%     title({'median image'});
%     imshow(simpleMedian);
%     subplot(2,2,3);
%     title({'median image 2'});
%     imshow(videoMedian2);
%     subplot(2,2,4);
%     title({'median image 3'});
%     imshow(videoMedian3);
    
%     figure;
%     imshow(videoMedian3);
    
%     imwrite(videoMedian3,'backgroundImg.png');
end

backgroundImg = videoMedian3;

end

