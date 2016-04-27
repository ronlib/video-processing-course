function S_next_tag = sampleParticles(S_prev, C)
    num_samples = 200;
    S_next_tag = zeros(size(S_prev, 1), num_samples);
    random_samples = unifrnd(0,1,1,num_samples);
    
    for i=[1:num_samples]
        temp_C = C - random_samples(i);
        positive_indices = find(temp_C.*(temp_C>0));
        S_next_tag(i) = positive_indices(1);
    end















end 
