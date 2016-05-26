function im_out = toy_reconstruct(im)

[imh, imw, nb] = size(im);
im2var = zeros(imh, imw); 
im2var(1:imh*imw) = 1:imh*imw; 

[gx gy] = gradient(im);

b = [];
A = sparse([]);
e = 1;
  
for x = 1:imw
    for y = 1:imh
        if ~(x == imw)
            A(e, im2var(y,x+1))=1;
            A(e, im2var(y,x))=-1;
            b(e) = im(y,x+1)-im(y,x);
            e = e+1;
        end
    end
end

for x = 1:imw
    for y = 1:imh
        if ~(y == imh)
            A(e, im2var(y+1,x))=1;
            A(e, im2var(y,x))=-1;
            b(e) = im(y+1,x)-im(y,x);
            e = e+1;
        end
    end
end

A(e, im2var(1,1))=1; 
b(e)=im(1,1);

v = lscov(A, b');
v = reshape(v,[imh, imw]);
im_out = v;
imshow(v);
display(size(A));