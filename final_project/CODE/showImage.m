function showImage(handles, image)    
    
    if ~isempty(handles)
%         axes(handles.axes1);
        imshow(image, 'Parent', handles.axes1);
        drawnow();
    else
        imshow(image);
    end
end