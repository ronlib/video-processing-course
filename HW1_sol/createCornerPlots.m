function createCornerPlots(I1 , I1_CORNERS , I2 , I2_CORNERS)

    [i1_corners_row,i1_corners_col] = find(I1_CORNERS);
    
    subplot(1,2,1);
    imshow(I1), title('Original image');
    hold on;
    plot(i1_corners_col,i1_corners_row,'ro','linewidth',5);
    hold off;
    
    [i2_corners_row,i2_corners_col] = find(I2_CORNERS);
    
    subplot(1,2,2);
    imshow(I2), title('Original image');    
    hold on;    
    plot(i2_corners_col,i2_corners_row,'ro','linewidth',2);    
    hold off;        

end