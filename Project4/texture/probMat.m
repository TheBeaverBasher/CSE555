function P = probMat(D)

sigma = mean(D(:))*2;
l = size(D,1);
P = zeros(l);

for i = 1:l-1
    for j = 1:l
        P(i,j) = exp(-D(i+1,j)/sigma);
    end;
end;

P = normr(P(1:l-1,:));