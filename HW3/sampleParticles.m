function S_next_tag = sampleParticles(S_prev, C)
    num_samples = 100;
    S_next_tag = zeros(size(S_prev, 1), num_samples);
    random_samples = unifrnd(0,1,1,num_samples);

    for i=[1:num_samples]
        positive_indices = find(C>=random_samples(i), 1, 'first');
        S_next_tag(:, i) = S_prev(:,positive_indices(1));
    end
end
