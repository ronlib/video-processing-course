function stateVectors = randomStateVectors(S, deviation_params)
    stateVectors = S;
    noise_mat = round(repmat(deviation_params, 1, size(S,2)).*randn(size(deviation_params, 1), size(S,2)));
    stateVectors = stateVectors + noise_mat;
end