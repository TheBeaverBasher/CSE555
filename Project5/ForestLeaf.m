clear all
load('sepDataLeaf.mat');

xTrLeaf = xTrLeaf(:,1:7754,:);
xTrLeafF = xTrLeafF(:,1:7754,:);

yTrLeaf = horzcat(yTrLeaf);
yTrLeaf=yTrLeaf(~cellfun('isempty',yTrLeaf));
yTrLeaf = reshape(yTrLeaf, [4,size(xTrLeaf,2)]);

[a, b, c] = unique(yTrLeaf(2,:), 'stable');

correctFLeaf = zeros(1,6);

n = size(c,1);

I = randsample(1:n,n);
J = I(1:round(.9*n));
K = I(round(.9*n)+1:end);

for i = 1:6
    if i < 5
        x = xTrLeaf(:,J,i);
        y = c(J)';
        FLeaf = forest(x,y,10);

        xVal = xTrLeaf(:,K,i);
        yVal = c(K)';
    else
        x = xTrLeafF(:,J,i-4);
        y = c(J)';
        FLeaf = forest(x,y,10);

        xVal = xTrLeafF(:,K,i-4);
        yVal = c(K)';      
    end;

    preds = evalforest(FLeaf,xVal);
    correctFLeaf(i) = sum(yVal == preds)/size(preds,2);
end

save('accuracy.mat', 'correctFLeaf', '-append');