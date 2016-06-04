function plotRectangle(handles, s, color)    
    
    rectangle('Position', [s(1)-s(3), s(2)-s(4), 2*s(3), 2*s(4)], 'Edgecolor', color, 'LineWidth', 1);
    if ~isempty(handles)
        set(handles.axes1, 'SortMethod', 'childorder');
        drawnow();
    end
end