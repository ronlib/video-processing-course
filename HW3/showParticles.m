function showParticles(I,S,W,i,ID)
 
figure
imshow(I);
title([ID ' - Frame number = ' num2str(i)]);
 

% ADD CODE LINES HERE TO PLOT THE RED AND GREEN RECTANGLE ABOVE THE IMAGE
% DO NOT DELETE THE ORIGINAL CODE LINES 3-5 AND 12-13

% Calculating weighted mean using W
mean_s = round(sum(S.*repmat(W, size(S, 1), 1), 2));
[m,m_i] = max(W);
max_s = S(:, m_i);

hold on;
plotRectangle(max_s, 'g');
plotRectangle(mean_s, 'r');


print(1, '-dpng', '-r300','-noui',[ID,'_HW3_',num2str(i),'.png'])
close all

end

function plotRectangle(s, color)
    plot([s(1)-s(3), s(1)+s(3)], [s(2)+s(4), s(2)+s(4)], color, 'Linewidth', 1);
    plot([s(1)-s(3), s(1)+s(3)], [s(2)-s(4), s(2)-s(4)], color, 'Linewidth', 1);
    plot([s(1)-s(3), s(1)-s(3)], [s(2)-s(4), s(2)+s(4)], color, 'Linewidth', 1);
    plot([s(1)+s(3), s(1)+s(3)], [s(2)-s(4), s(2)+s(4)], color, 'Linewidth', 1);
end

