function w = compBatDist(p,q)
    sum_sqrt = sum(sqrt(p.*q));
%     20 makes it explode...
    w = exp(10*sum_sqrt);
end