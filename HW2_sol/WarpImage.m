function I_warp = WarpImage(I,u,v)
    u(isnan(u)) = 0;
    v(isnan(v)) = 0;
    
    u(isinf(u)) = 0;
    v(isinf(v)) = 0;
    
    warp(:,:,1) = u;
    warp(:,:,2) = v;
    
    I_warp = imwarp(I, warp);

end