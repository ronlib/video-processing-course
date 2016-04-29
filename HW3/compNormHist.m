function normHist = compNormHist(I,s)
    x_b = s(1)-s(3);
    x_e = s(1)+s(3);
    y_b = s(2)-s(4);
    y_e = s(2)+s(4);

%     fprintf('%d %d %d %d\n', y_b, y_e, x_b, x_e);
    sub_I = I(y_b:y_e, x_b:x_e,:);

%     Making sure imquantize would map the image to 16 levels only, by
%     setting one of the levels to max(uint8), 256
    levels = [15:16:256];
    quantized_image = zeros(size(sub_I));
    quantized_image(:,:,1) = imquantize(sub_I(:,:,1), levels)*16^2;
    quantized_image(:,:,2) = imquantize(sub_I(:,:,2), levels)*16^1;
    quantized_image(:,:,3) = imquantize(sub_I(:,:,3), levels)*16^0;

    quantized_image_sum = sum(quantized_image, 3);
    normHist = hist(quantized_image_sum(:), [0:1:16^3]);

%     normHist = zeros(16^3, 1);

%     TODO: find a better implementation



% for i=[y_b:y_e]
%         for j=[x_b:x_e]
%             color_quantized = uint16(fix(I(i,j,1)/16))*256 + uint16(fix(I(i,j,2)/16))*16 + uint16(fix(I(i,j,3)/16)) + 1;
%             normHist(color_quantized) = normHist(color_quantized) + 1;
%         end
%     end

    normHist = normHist/sum(normHist);
end
