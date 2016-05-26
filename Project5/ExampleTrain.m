clear all
load('sepDataBranch.mat');

yTrBranch = horzcat(yTrBranch);
yTrBranch=yTrBranch(~cellfun('isempty',yTrBranch));
yTrBranch = reshape(yTrBranch, [4,1987]);

% xTrBranch = xTrBranch(:,1:7754,:);
% xTrBranchF = xTrBranchF(:,1:7754,:);

[a, b, c] = unique(yTrBranch(2,:), 'stable');

I = randsample(1:1987,1987);
J = I(1:1789);
K = I(1790:1987);

x = xTrBranchF(:,J,2);
y = c(J)';

rbfNetBranch17 = newrb(x, y, 2500);

xVal = xTrBranchF(:,K,2);
yVal = c(K)';

preds = rbfNetBranch17(xVal);
display(sum(yVal == round(preds))/size(preds,2));

% rbfNetBranch18 = newrb(xTrBranch(:,:,2), c');
% rbfNetBranch19 = newrb(xTrBranch(:,:,3), c');
% rbfNetBranch20 = newrb(xTrBranch(:,:,4), c');
% rbfNetBranch21 = newrb(xTrBranch(:,:,1), c');
% rbfNetBranch22 = newrb(xTrBranchF(:,:,2), c');
% 
% rbfNetBranch17(xTeBranch(:,1,1));
% 
% 
% x = xTrBranch(:,J,1);
% y = c(J)';
% F = forest(x,y,25);
