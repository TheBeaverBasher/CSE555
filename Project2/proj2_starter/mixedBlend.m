function im_blend = mixedBlend(im_s, mask_s, im_background)

[imh, imw, nb] = size(im_background); 
im2var = zeros(imh, imw);
im2var(1:imh*imw) = 1:imh*imw; 

M = 2*imh*imw;
N = imh*imw;

e = 0;
A = sparse([], [], [], M, N, 0);
b = zeros(M, 1); 

flag = 0;

for y = 1:imh
    for x = 1:imw
        if (flag == 0)
        if (mask_s(y,x)==1)
            start_x  = x;
            start_y  = y;
            end_x = x;
            end_y = y;    
            flag = 1;
        end    
        end
        if (mask_s(y,x)==1)
            if (x<start_x) 
                start_x = x;
            end
            if (y<start_y) 
                start_y = y;
            end
            if (x>end_x) 
                end_x = x;
            end
            if (y>start_y) 
                end_y = y;
            end
        end    
        
    end        
end

for z=1:3           
e=0;                           
    for x=start_x:end_x
        for y=start_y:end_y
            if(mask_s(y,x)==1)
                if(mask_s(y,x+1)==1)
                    e = e+1;
                    A(e, im2var(y,x+1))=1;
                    A(e, im2var(y,x))=-1;
                    b(e) = max(im_s(y,x+1,z)-im_s(y,x,z), im_background(y,x+1,z)-im_background(y,x,z)); 
                else     
                    e=e+1; 
                    A(e, im2var(y,x+1))=0;
                    A(e, im2var(y,x))=-1; 
                    b(e) = max(im_s(y,x+1,z)-im_s(y,x,z), im_background(y,x+1,z)-im_background(y,x,z)) - im_background(y,x+1,z);                 
                end;
                     
                if(mask_s(y+1,x)==1)
                    e = e+1;
                    A(e, im2var(y+1,x))=1;
                    A(e, im2var(y,x))=-1;
                    b(e) = max(im_s(y+1,x,z)-im_s(y,x,z), im_background(y+1,x,z)-im_background(y,x,z)); 
                else     
                    e=e+1; 
                    A(e, im2var(y+1,x))=0;
                    A(e, im2var(y,x))=-1; 
                    b(e) = max(im_s(y+1,x,z)-im_s(y,x,z), im_background(y+1,x,z)-im_background(y,x,z)) - im_background(y+1,x,z);                 
                end;
                  
                if(mask_s(y,x-1)==1)
                    e=e+1; 
                    A(e, im2var(y,x-1))=1; 
                    A(e, im2var(y,x))=-1; 
                    b(e) = max(im_s(y,x-1,z)-im_s(y,x,z), im_background(y,x-1,z)-im_background(y,x,z));
                else
                    e=e+1; 
                    A(e, im2var(y,x-1))=0;
                    A(e, im2var(y,x))=-1; 
                    b(e) = max(im_s(y,x-1,z)-im_s(y,x,z), im_background(y,x-1,z)-im_background(y,x,z)) -im_background(y,x-1,z);                 
                end;
                
                if(mask_s(y-1,x)==1)
                    e=e+1; 
                    A(e, im2var(y-1,x))=1; 
                    A(e, im2var(y,x))=-1; 
                    b(e) = max(im_s(y-1,x,z)-im_s(y,x,z), im_background(y-1,x,z)-im_background(y,x,z));
                else
                    e=e+1; 
                    A(e, im2var(y-1,x))=0; 
                    A(e, im2var(y,x))=-1; 
                    b(e) = max(im_s(y-1,x,z)-im_s(y,x,z), im_background(y-1,x,z)-im_background(y,x,z)) -im_background(y-1,x,z);
                end;      
            end
        end
    end
   
     
v = A\b;
im_out(:,:,z) = reshape(v,imh,imw);

end 

mask(:,:,1)=mask_s;
mask(:,:,2)=mask_s;
mask(:,:,3)=mask_s;

im_blend = mask.*im_out + (1-mask).*im_background;

end