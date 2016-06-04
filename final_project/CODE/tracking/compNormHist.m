function normHist = compNormHist(I,s)
    x_b = s(1)-s(3);
    x_e = s(1)+s(3);
    y_b = s(2)-s(4);
    y_e = s(2)+s(4);

    sub_I = im2uint8(I(y_b:y_e, x_b:x_e,:));

%     Making sure imquantize would map the image to 16 levels only, by
%     setting one of the levels to max(uint8), 256
    levels = 15:16:256;
    quantized_image = zeros(size(sub_I));
    quantized_image(:,:,1) = imquantize(sub_I(:,:,1), levels)*16^2;
    quantized_image(:,:,2) = imquantize(sub_I(:,:,2), levels)*16^1;
    quantized_image(:,:,3) = imquantize(sub_I(:,:,3), levels)*16^0;

    quantized_image_sum = sum(quantized_image, 3);
    normHist = hist(quantized_image_sum(:), 0:1:16^3);
    normHist = normHist/sum(normHist);
end
