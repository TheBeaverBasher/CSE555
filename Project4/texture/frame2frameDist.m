function D = frame2frameDist(imageStack)

[h, w, c, l] = size(imageStack);

D = zeros(l);

for channel = 1:c
    for i = 1:l
        for j = i:l
            D(i,j) = D(i,j) + norm(imageStack(:,:,channel,i)-imageStack(:,:,channel,j));
        end;
    end;
end;
D = triu(D)+triu(D,1)';
