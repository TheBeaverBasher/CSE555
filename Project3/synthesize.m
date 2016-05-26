function [out_image, blocksize] = synthesize(in_image, n, blocksize, minpath, overlap)

X = double(in_image);

blocksize = round(min(size(X,1),size(X,2))*blocksize);
overlap = round(blocksize / (24/overlap));
minimum_error = 0.002;

outsize = n * blocksize - (n-1) * overlap;

Y = zeros(outsize, outsize, 3);

for i=1:n
    for j=1:n
        startI = (i-1)*blocksize - (i-1) * overlap + 1;
        startJ = (j-1)*blocksize - (j-1) * overlap + 1;
        endI = startI + blocksize - 1;
        endJ = startJ + blocksize - 1;
        
        errors_of_all_patches = zeros(size(X,1)-blocksize, size(X,2)-blocksize);
        
        if (j > 1)
            errors_of_all_patches = ssd(X, Y(startI:endI, startJ:startJ+overlap-1, 1:3));    
            errors_of_all_patches = errors_of_all_patches(1:end, 1:end-blocksize+overlap);
        end;
        
        if (i > 1)
            Z = ssd(X, Y(startI:startI+overlap-1, startJ:endJ, 1:3));
            Z = Z(1:end-blocksize+overlap, 1:end);
            if (j > 1) 
                errors_of_all_patches = errors_of_all_patches + Z;
            else
                errors_of_all_patches = Z;
            end;
        end;
        
        if (i > 1 && j > 1)
            Z = ssd(X, Y(startI:startI+overlap-1, startJ:startJ+overlap-1, 1:3));
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
            
            if( i == 1 && j == 1 )
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