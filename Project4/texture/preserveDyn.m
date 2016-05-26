function Dprime = preserveDyn(D)

l = size(D,1);

Dprime = zeros(l);
w = [1/4, 1/4, 1/4, 1/4];

for i = 3:l-1
    for j = 3:l-1
        for k = -2:1
            Dprime(i,j) = Dprime(i,j) + w(k+3)*D(i+k,j+k);
        end;
    end;
end;

Dprime = Dprime(3:l-1,3:l-1);