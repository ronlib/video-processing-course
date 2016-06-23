function [T, outStauts] = findImagesTransformation(I1, I2)
    N = 100;

    %I1Corners = detectHarrisFeatures(I1);
    %I2Corners = detectHarrisFeatures(I2);
    %I1Corners = detectSURFFeatures(I1);
    %I2Corners = detectSURFFeatures(I2);
    I1Corners = detectSURFFeatures(I1, 'NumOctaves', 2, 'NumScaleLevels', 3);
    I1Corners = I1Corners.selectStrongest( min( 200, length(I1Corners) ));
    I2Corners = detectSURFFeatures(I2, 'NumOctaves', 2, 'NumScaleLevels', 3);
    I2Corners = I2Corners.selectStrongest( min( 200, length(I2Corners) ));

    [featuresI1,validPtsI1] = extractFeatures(I1, I1Corners);
    [featuresI2,validPtsI2] = extractFeatures(I2, I2Corners);

    matchedIndices = matchFeatures(featuresI1, featuresI2);
%     showMatchedFeatures(I1, I2, validPtsI1(matchedIndices(:,1)), validPtsI2(matchedIndices(:,2)), 'falsecolor');

    %[tform,inlierpoints1,inlierpoints2, status] = estimateGeometricTransform(validPtsI2(matchedIndices(:,2)), ...
    %    validPtsI1(matchedIndices(:,1)), 'projective');
    [tform,~,~, status] = estimateGeometricTransform(validPtsI2(matchedIndices(:,2)), ...
        validPtsI1(matchedIndices(:,1)), 'similarity','Confidence',99,'MaxDistance',0.5);

    T = tform;
    outStauts = status;

end
