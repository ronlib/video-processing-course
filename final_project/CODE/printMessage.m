function printMessage(handles, message)
    if ~isempty(handles)
        set(handles.text4, 'String', message);
        drawnow();
    else
        fprintf(message);
    end
end