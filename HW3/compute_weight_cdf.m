function [C,W] = compute_weight_cdf(q,S,I)
    W = zeros(1, length(S));
    C = zeros(1, length(S));
    for i=[1:length(S)]
        W(i) = compBatDist(q, compNormHist(I, S(:,i)));
        if ~(i == 1)
            C(i) = C(i-1) + W(i);
        else
            C(i) = W(i);
        end
    end
    sum_W = sum(W);
    C = C / sum_W;
    W = W / sum_W;
end