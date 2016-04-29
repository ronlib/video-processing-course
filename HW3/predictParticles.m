function S_next = predictParticles(S_next_tag)
    S_next = S_next_tag;
    S_next(1,:) = S_next(1,:) + S_next(5,:);
    S_next(2,:) = S_next(2,:) + S_next(6,:);
    
    S_next = randomStateVectors(S_next, [0.5, 0.5, 1, 1, 1, 1]');
    
%     S_next = S_next(:, S_next(:,1)>=1 & S_next(:,1)>=1
%     TODO: should check for out of boundary particles?
end
