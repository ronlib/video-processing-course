function [absPath] = getFileAbsPath(path)
    [status, struct] = fileattrib(path);
    absPath = '';
    if status == 1
        absPath = struct.Name;
    end    
end