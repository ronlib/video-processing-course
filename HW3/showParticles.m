function showParticles(I,S,W,i,ID)
 
figure
imshow(I);
title([ID ' - Frame number = ' num2str(i)]);
 

% ADD CODE LINES HERE TO PLOT THE RED AND GREEN RECTANGLE ABOVE THE IMAGE
% DO NOT DELETE THE ORIGINAL CODE LINES 3-5 AND 12-13


print(1, '-dpng', '-r300','-noui',[ID,'_HW3_',num2str(i),'.png'])
close

end

