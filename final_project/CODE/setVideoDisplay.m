function setVideoDisplay(hObject, handles, videoFilePath)
    handles.videoObject = vision.VideoFileReader(videoFilePath);
    guidata(hObject, handles);
    printMessage(handles, sprintf('Click Play to start video\n'));
end