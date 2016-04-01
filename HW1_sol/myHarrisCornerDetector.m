 function corners = myHarrisCornerDetector(I, k, threshold)
 
 if (ndims(I) == 3)
    grayI = rgb2gray(I);
 else
     grayI = I;
 end
 
 dim1 = size(grayI,1);
 dim2 = size(grayI,2);
     
 % find derivative
 I_shifted_right = [zeros(dim1,1) grayI(:,1:dim2-1)];
 I_shifted_down = [zeros(1,dim2); grayI(1:dim1-1,:)];
 Ix = grayI-I_shifted_right;
 Iy = grayI-I_shifted_down;  
 
 BWmap = zeros(size(grayI)); 
 
 for i=3:(size(grayI,1)-2)
     for j=3:(size(grayI,2)-2)         
        
         M11 = sum(sum(Ix(i-2:i+2,j-2:j+2).^2));
         M12 = sum(sum(Ix(i-2:i+2,j-2:j+2).*Iy(i-2:i+2,j-2:j+2)));         
         M21 = M12;
         M22 = sum(sum(Iy(i-2:i+2,j-2:j+2).^2));         
         
         M = [M11 M12; M21 M22];
         
         BWmap(i,j) = (det(M)-k*(trace(M))^2 >= threshold);
             
     end
 end    
 
 %figure, imshow(I), title('Original image');
 %figure, imshow( Ix.^2+Iy.^2), title('derivative image');
 %figure, imshow(BWmap), title('corners image');
 
 corners = BWmap;
 
 end
 
 