clear all
load('sepDataBranch.mat');

yTrBranch = horzcat(yTrBranch);
yTrBranch=yTrBranch(~cellfun('isempty',yTrBranch));
yTrBranch = reshape(yTrBranch, [4,size(xTrBranch,2)]);

[a, b, c] = unique(yTrBranch(2,:), 'stable');

correctFBranch = zeros(1,6);

n = size(c,1);

I = randsample(1:n,n);
J = I(1:round(.9*n));
K = I(round(.9*n)+1:end);

for i = 1:6
    if i < 5
        x = xTrBranch(:,J,i);
        y = c(J)';
        F = forest(x,y,10);

        xVal = xTrBranch(:,K,i);
        yVal = c(K)';
    else
        x = xTrBranchF(:,J,i-4);
        y = c(J)';
        F = forest(x,y,10);

        xVal = xTrBranchF(:,K,i-4);
        yVal = c(K)';      
    end;

    preds = evalforest(F,xVal);
    correctFBranch(i) = sum(yVal == preds)/size(preds,2);
end

save('accuracy.mat', 'correctFBranch', '-append');