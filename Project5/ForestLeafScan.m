clear all
load('sepDataLeafScan.mat');

yTrLeafScan = horzcat(yTrLeafScan);
yTrLeafScan=yTrLeafScan(~cellfun('isempty',yTrLeafScan));
yTrLeafScan = reshape(yTrLeafScan, [4,size(xTrLeafScan,2)]);

[a, b, c] = unique(yTrLeafScan(2,:), 'stable');

correctFLeafScan = zeros(1,6);

n = size(c,1);

I = randsample(1:n,n);
J = I(1:round(.9*n));
K = I(round(.9*n)+1:end);

for i = 1:6
    if i < 5
        x = xTrLeafScan(:,J,i);
        y = c(J)';
        F = forest(x,y,10);

        xVal = xTrLeafScan(:,K,i);
        yVal = c(K)';
    else
        x = xTrLeafScanF(:,J,i-4);
        y = c(J)';
        F = forest(x,y,10);

        xVal = xTrLeafScanF(:,K,i-4);
        yVal = c(K)';      
    end;

    preds = evalforest(F,xVal);
    correctFLeafScan(i) = sum(yVal == preds)/size(preds,2);
end

save('accuracy.mat', 'correctFLeafScan', '-append');