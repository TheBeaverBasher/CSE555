function out_image = transfer(in_image, constraint, alpha, minpath)

X = double(in_image);

blocksize = round(min(size(X,1),size(X,2))*.1);
overlap = round(blocksize / 6);
minimum_error = 0.01;

W = zeros(size(constraint,1)+blocksize+overlap, size(constraint,2)+blocksize+overlap, 3);
W(1:size(constraint,1), 1:size(constraint,2), :) = double(constraint);

Y = zeros(size(W,1), size(W,2), 3);

m = ceil(size(W,1)/blocksize);
n = ceil(size(W,2)/blocksize);

for i=1:m+3
    for j=1:n+2
        startI = (i-1)*blocksize - (i-1) * overlap + 1;
        startJ = (j-1)*blocksize - (j-1) * overlap + 1;
        endI = startI + blocksize - 1;
        endJ = startJ + blocksize - 1;
        
        errors_of_all_patches = zeros(size(X,1)-blocksize, size(X,2)-blocksize);
        
        if (i == 1 && j == 1)
            errors_of_all_patches = (1-alpha)*ssd(X,W(startI:endI, startJ:endJ, 1:3));
        end;    
        
        if (j > 1)
            A = ssd(X, Y(startI:endI, startJ:startJ+overlap-1, 1:3));
            Btemp = ssd(X,W(startI:endI, startJ:endJ, 1:3));
            B = zeros(size(A,1), size(A,2));
            B(1:size(Btemp,1),1:size(Btemp,2),:) = Btemp;
            
            errors_of_all_patches = alpha*A + (1-alpha)*B;
            
            errors_of_all_patches = errors_of_all_patches(1:end, 1:end-blocksize+overlap);
        end;
        
        if (i > 1)
            A = ssd(X, Y(startI:startI+overlap-1, startJ:endJ, 1:3));
            Btemp = ssd(X,W(startI:endI, startJ:endJ, 1:3));
            B = zeros(size(A,1), size(A,2));
            B(1:size(Btemp,1),1:size(Btemp,2),:) = Btemp;
            
            Z = alpha*A + (1-alpha)*B;
            Z = Z(1:end-blocksize+overlap, 1:end);
            if (j > 1) 
                errors_of_all_patches = errors_of_all_patches + Z;
            else
                errors_of_all_patches = Z;
            end;
        end;
        
        if (i > 1 && j > 1)
            A = ssd(X, Y(startI:startI+overlap-1, startJ:startJ+overlap-1, 1:3));
            Btemp = ssd(X,W(startI:endI, startJ:endJ, 1:3));
            B = zeros(size(A,1), size(A,2));
            B(1:size(Btemp,1),1:size(Btemp,2),:) = Btemp;
            
            Z = alpha*A + (1-alpha)*B;
            Z = Z(1:end-blocksize+overlap, 1:end-blocksize+overlap);                   
            errors_of_all_patches = errors_of_all_patches - Z;
        end;
        
        best = min(errors_of_all_patches(:));
        candidates = find(errors_of_all_patches(:) <= (1+minimum_error)*best);
          
        idx = candidates(ceil(rand(1)*length(candidates)));
                         
        [sub(1), sub(2)] = ind2sub(size(errors_of_all_patches), idx);
        
        if (minpath)
            mask = ones(blocksize, blocksize);
            
            if (j > 1)
                E = (X(sub(1):sub(1)+blocksize-1, sub(2):sub(2)+overlap-1) - Y(startI:endI, startJ:startJ+overlap-1)).^2;
                C = mincut(E, 0);
                mask(1:end, 1:overlap) = double(C >= 0);
            end;
            
            if (i > 1)
                E = (X(sub(1):sub(1)+overlap-1, sub(2):sub(2)+blocksize-1) - Y(startI:startI+overlap-1, startJ:endJ)).^2;
                C = mincut(E, 1);
                mask(1:overlap, 1:end) = mask(1:overlap, 1:end) .* double(C >= 0);
            end; 
            
            if (i == 1 && j == 1)
                Y(startI:endI, startJ:endJ, 1:3) = X(sub(1):sub(1)+blocksize-1, sub(2):sub(2)+blocksize-1, 1:3);
            else
                Y(startI:endI, startJ:endJ, :) = filtered_write(Y(startI:endI, startJ:endJ, :), ...
                    X(sub(1):sub(1)+blocksize-1, sub(2):sub(2)+blocksize-1, :), mask); 
            end;
            
        else
            Y(startI:endI, startJ:endJ, 1:size(X,3)) = X(sub(1):sub(1)+blocksize-1, sub(2):sub(2)+blocksize-1, 1:size(X,3));
        end;    
        image(uint8(Y));
        drawnow;
    end;
end;

out_image = uint8(Y);
out_image = out_image(1:size(constraint,1),1:size(constraint,2),:);
imshow(out_image);


function A = filtered_write(A, B, mask)
for i = 1:3
    A(:, :, i) = A(:,:,i) .* (mask == 0) + B(:,:,i) .* (mask == 1);
end;

function Z = ssd(X, Y)

K = ones(size(Y,1), size(Y,2));

for k=1:size(X,3),
    A = X(:,:,k);
    B = Y(:,:,k);
    
    a2 = filter2(K, A.^2, 'valid');
    b2 = sum(sum(B.^2));
    ab = filter2(B, A, 'valid').*2;

    if( k == 1 )
        Z = ((a2 - ab) + b2);
    else
        Z = Z + ((a2 - ab) + b2);
    end;
end;