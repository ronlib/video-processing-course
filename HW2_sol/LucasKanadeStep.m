function [du, dv] = LucasKanadeStep(I1, I2, WindowSize)
   du = zeros(size(I1));
   dv = zeros(size(I1));
   
   [ix, iy] = gradient(I2);
   ixx = imfilter(ix.*ix, ones(WindowSize));
   iyy = imfilter(iy.*iy, ones(WindowSize));
   ixy = imfilter(ix.*iy, ones(WindowSize));
   it = I2 - I1;
   
   w = fix(WindowSize/2);
   
   for i = [w+1:size(I1,1)-w]
       for j = [w+1:size(I1,2)-w]
             
            BtB = [ixx(i,j), ixy(i,j);
                   ixy(i,j), iyy(i,j)];
               
            B_it = [sum(sum(it(i-w:i+w, j-w:j+w) ...
                        .*ix(i-w:i+w, j-w:j+w))) ; 
                    sum(sum(it(i-w:i+w, j-w:j+w) ...
                        .*iy(i-w:i+w, j-w:j+w))) ];
            
%             if det(BtB) == 0
%                 delta_p = [0 0];
%             else
                delta_p = -pinv(BtB)*B_it;
%             end
            du(i,j) = delta_p(1);
            dv(i,j) = delta_p(2);
       end
   end

end