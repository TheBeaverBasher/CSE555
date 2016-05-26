function [ypredict]=evaltree(T,xTe)
% function [ypredict]=evaltree(T,xTe);
%
% input:
% T0  | tree structure
% xTe | Test data (dxn matrix)
%
% output:
%
% ypredict : predictions of labels for xTe
%

%% fill in code here

[d, n] = size(xTe);
ypredict = zeros(1,n);

for i = 1:n
    x = xTe(:,i);
    t = T(:,1);
    
    while t(4) ~= 0
        if (x(t(2)) <= t(3))
            t = T(:,t(4));
        else
            t = T(:,t(5));
        end;
    end;
    
    ypredict(i) = t(1);
    
end;

