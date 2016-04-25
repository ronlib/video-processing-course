function stateVectors = randomStateVectors(S, deviation_params)
%     im_size = size(I);
    i = 2;
    stateVectors = S;
        
    while i <= size(S, 2)
        stateVectors(:, i) = stateVectors(:, i) + normnd(s_initial, deviation_params);
        
%         TODO check if boundries should be checked
        if 1
%         if ~(stateVectors(1, i) + stateVectors(3, i) > im_size(2) || stateVectors(1, i) - stateVectors(3, i) < 1 ...
%             || stateVectors(1, i) + stateVectors(3, i) + stateVectors(5, i) > im_size(2) || stateVectors(1, i) - stateVectors(3, i) + stateVectors(5, i) < 1 ...
%             || stateVectors(2, i) + stateVectors(4, i) > im_size(1) || stateVectors(2, i) - stateVectors(4, i) < 1 ...
%             || stateVectors(2, i) + stateVectors(4, i) + stateVectors(6, i) > im_size(1) || stateVectors(2, i) - stateVectors(4, i) + stateVectors(6, i) < 1)
        
            i = i + 1;
        end
    end
    
end