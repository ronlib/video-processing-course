function [T, outStauts] = findImagesTransformation(I1, I2)
    N = 100;

    I1Corners = detectHarrisFeatures(I1);
    I2Corners = detectHarrisFeatures(I2);

    [featuresI1,validPtsI1] = extractFeatures(I1, I1Corners);
    [featuresI2,validPtsI2] = extractFeatures(I2, I2Corners);

    matchedIndices = matchFeatures(featuresI1, featuresI2);
%     showMatchedFeatures(I1, I2, validPtsI1(matchedIndices(:,1)), validPtsI2(matchedIndices(:,2)), 'falsecolor');

    [tform,inlierpoints1,inlierpoints2, status] = estimateGeometricTransform(validPtsI2(matchedIndices(:,2)), ...
        validPtsI1(matchedIndices(:,1)), 'similarity');

    T = tform;
    outStauts = status;

end
