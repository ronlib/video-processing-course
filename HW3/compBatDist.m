function w = compBatDist(p,q)
    sum_sqrt = sum(sqrt(p.*q));
    w = exp(20*sum_sqrt);
end