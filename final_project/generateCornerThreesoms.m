function [I1CornersThreesoms, I2CornersThreesoms] = generateCornerThreesoms(I1Corners, I2Corners, nThreesoms)
%     TODO: Choose the samples in a smarter way (e.g, limit to a window)

    I1CornersThreesoms = zero(3, nThreesoms);
    I2CornersThreesoms = zero(3, nThreesoms);
   
    for i=[1, nThreesoms]
        I1CornersThreesoms = datasample(I1Corners, 3);
        I2CornersThreesoms = datasample(I2Corners, 3);
    end   
   
end