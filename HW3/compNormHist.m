function normHist = compNormHist(I,s)
    x_b = s(1)-s(3);
    x_e = s(1)+s(3);   
    y_b = s(2)-s(4);
    y_e = s(2)+s(4);
    
    normHist = zeros(16^3, 1);

%     TODO: find a better implementation
    for i=[y_b:y_e]
        for j=[x_b:x_e]
            color_quantized = uint16(fix(I(i,j,1)/16))*256 + uint16(fix(I(i,j,2)/16))*16 + uint16(fix(I(i,j,3)/16)) + 1;
            normHist(color_quantized) = normHist(color_quantized) + 1;
        end
    end
    
    normHist = normHist/sum(normHist);
end