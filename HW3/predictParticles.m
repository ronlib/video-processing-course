function S_next = predictParticles(S_next_tag)
    S_next = S_next_tag;
    for i=[1:size(S_next_tag(2))]
        S_next(1) = S_next(1) + S_next(5);
        S_next(2) = S_next(2) + S_next(6);
    end
    S_next = randomStateVectors(S_next, [7, 5, 2, 4, 3, 3]');
%     TODO: should check for out of boundary particles?
end
