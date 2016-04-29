function filtered_S = filterParticles(I,S)
    [height,width] = size(I);
    f = ~(S(3,:) < 1 | S(4,:) < 1 | ...
        S(1,:)-S(3,:) < 1 | S(2,:)-S(4,:) < 1 | ...
        S(1,:)+S(3,:) > width | S(2,:)+S(4,:) > height);
    
%     TODO: remove
    if ~ isempty(find(f==0))
        fprintf('filtered out %d values!\n', length(find(f==0)));
    end
    
    filtered_S = S(:, f);
end