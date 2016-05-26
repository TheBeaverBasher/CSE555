function F=forest(x,y,nt)
% function F=forest(x,y,nt)
%
% INPUT:
% x | input vectors dxn
% y | input labels 1xn
%
% OUTPUT:
% F | Forest
%

%% fill in code here

[d, n] = size(x);

for i = 1:nt
    I = datasample((1:n),n);
    newX = x(:,I);
    newY = y(I);
    T = id3tree(newX,newY);
    if i == 1
        F = zeros(6,size(T,2),nt);
    else
        if (size(F,2) < size(T,2))
            Ftemp = zeros(6,size(T,2), nt);
            Ftemp(:,1:size(F,2),:) = F;
            F = Ftemp;
        end;
        F(:,1:size(T,2),i) = T;
    end;
    display('done with a tree!');
    
end;


