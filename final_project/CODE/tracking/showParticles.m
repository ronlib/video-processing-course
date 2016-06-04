function showParticles(handles, I,S,W)
 
% figure
imshow(I);
% title([ID ' - Frame number = ' num2str(i)]);
 

% ADD CODE LINES HERE TO PLOT THE RED AND GREEN RECTANGLE ABOVE THE IMAGE
% DO NOT DELETE THE ORIGINAL CODE LINES 3-5 AND 12-13

% Calculating weighted mean using W
mean_s = round(sum(S.*repmat(W, size(S, 1), 1), 2));
[~, m_i] = max(W);
max_s = S(:, m_i);

hold on;
% plotRectangle(handles, max_s, 'g');
plotRectangle(handles, mean_s, 'r');
drawnow();


% print(1, '-dpng', '-r300','-noui',[ID,'_HW3_',num2str(i),'.png'])
% close all

end