function I_warp = WarpImage(I,u,v)

    [xx,yy] = meshgrid(1:size(I,2),1:size(I,1));
    newX = xx + u;
    newY = yy + v;
    I_warp = interp2(xx,yy,I,newX,newY,'cubic');
    % Replace holes with the value they had in the original image
    nanIndx = isnan(I_warp);
    I_warp(nanIndx) = I(nanIndx);
    
end