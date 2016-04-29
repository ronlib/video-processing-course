function stateVectors = randomStateVectors(S, deviation_params)
%     im_size = size(I);
%     TODO: don't add noise to the position, but only to the speeds
    stateVectors = S;
    random_factor_mat = round(repmat(deviation_params, 1, size(S,2)).*randn(size(deviation_params, 1), size(S,2)));
%     max_rand = max(abs(random_factor_mat), 1);
%     fprintf('max: %d %d %d %d %d %d\n', max_rand(1),max_rand(2),max_rand(3),max_rand(4),max_rand(5),max_rand(6));
    stateVectors = stateVectors + random_factor_mat;
        
%     while i <= size(S, 2)
%         stateVectors(:, i) = stateVectors(:, i) + normnd(s_initial, deviation_params);
%         
% %         TODO check if boundries should be checked
%         if 1
% %         if ~(stateVectors(1, i) + stateVectors(3, i) > im_size(2) || stateVectors(1, i) - stateVectors(3, i) < 1 ...
% %             || stateVectors(1, i) + stateVectors(3, i) + stateVectors(5, i) > im_size(2) || stateVectors(1, i) - stateVectors(3, i) + stateVectors(5, i) < 1 ...
% %             || stateVectors(2, i) + stateVectors(4, i) > im_size(1) || stateVectors(2, i) - stateVectors(4, i) < 1 ...
% %             || stateVectors(2, i) + stateVectors(4, i) + stateVectors(6, i) > im_size(1) || stateVectors(2, i) - stateVectors(4, i) + stateVectors(6, i) < 1)
%         
%             i = i + 1;
%         end
%     end
    
end