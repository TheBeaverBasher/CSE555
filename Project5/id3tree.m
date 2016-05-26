function T=id3tree(xTr,yTr,maxdepth,weights)
% function T=id3tree(xTr,yTr,maxdepth,weights)
%
% The maximum tree depth is defined by "maxdepth" (maxdepth=2 means one split).
% Each example can be weighted with "weights".
%
% Builds an id3 tree
%
% Input:
% xTr | dxn input matrix with n column-vectors of dimensionality d
% yTr | 1xn input matrix
% maxdepth = maximum tree depth
% weights = 1xn vector where weights(i) is the weight of example i
%
% Output:
% T = decision tree
%

%% fill in code here
n = size(xTr,2);

if (nargin < 4)
    weights = ones(1,n);
    if (nargin < 3)
        maxdepth = inf;
    end;
end;


Tree = id3(xTr, yTr, weights, 1, maxdepth-1);
[dT, nT] = size(Tree);

for i = 1:nT
    index = Tree(7,i);
    T(:,index) = Tree(1:6,i);
end;

function Tree = id3(xTr, yTr, weights, node, maxdepth)

if (maxdepth < inf)
    q = 2^maxdepth;
    Tree = zeros(7,q);
end;

if (range(yTr)==0 || sum(range(xTr,2))==0 || maxdepth==0)
    Tree = [mode(yTr), 0, 0, 0, 0, floor(node/2), node]';
    return
else     
    [feature,cut,Hbest]=entropysplit(xTr,yTr,weights);
    
    [~, I] = sort(xTr(feature,:));
    xSorted = xTr(:,I);
    ySorted = yTr(I);
    L = find(xSorted(feature,:) <= cut);
    R = find(xSorted(feature,:) > cut);
    w = weights(I);
    
    Tree1 = [mode(yTr), feature, cut, 2*node, 2*node+1, floor(node/2), node]';
    
    xL = xSorted(:,L);
    xR = xSorted(:,R);
    yL = ySorted(:,L);
    yR = ySorted(:,R);
    wL = w(:,L);
    wR = w(:,R);
    
    TL = id3(xL,yL,wL,2*node, maxdepth-1);
    TR = id3(xR,yR,wR,2*node+1, maxdepth-1);
    
    Tree = [Tree1 TL TR];
end    