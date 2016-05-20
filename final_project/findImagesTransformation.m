function T = findImagesTransformation(I1, I2)  
    N = 100;

    I1Corners = detectHarrisFeatures(I1);
    I2Corners = detectHarrisFeatures(I2);
    
%     [I1CornersThreesoms, I2CornersThreesoms] = generateCornerThreesoms(I1Corners, I2Corners, N);
    [featuresI1,validPtsI1] = extractFeatures(I1, I1Corners);
    [featuresI2,validPtsI2] = extractFeatures(I2, I2Corners);
    
    
    
end