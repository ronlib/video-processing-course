function S_next_tag = sampleParticles(S_prev, C)
    num_samples = size(S_prev, 2);
    S_next_tag = zeros(size(S_prev, 1), num_samples);
    random_samples = unifrnd(0,1,1,num_samples);
    
    for i=[1:num_samples]
%         temp_C = C - random_samples(i);
        positive_indices = find(C>=random_samples(i));
        if length(positive_indices) == 0
            fprintf('random_samples(i): %d\n', random_samples(i));
            display(C);
        end
        S_next_tag(:, i) = S_prev(:,positive_indices(1));
    end
end
