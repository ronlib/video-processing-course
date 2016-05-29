function [absPath] = getFileAbsPath(path)
    [~, struct] = fileattrib(path);
    absPath = struct.Name;
end