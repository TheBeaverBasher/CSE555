clear all
load('sepDataFlower.mat');

yTrFlower = horzcat(yTrFlower);
yTrFlower=yTrFlower(~cellfun('isempty',yTrFlower));
yTrFlower = reshape(yTrFlower, [4,size(xTrFlower,2)]);

[a, b, c] = unique(yTrFlower(2,:), 'stable');

correctFFlower = zeros(1,6);

n = size(c,1);

I = randsample(1:n,n);
J = I(1:round(.9*n));
K = I(round(.9*n)+1:end);

for i = 1:6
    if i < 5
        x = xTrFlower(:,J,i);
        y = c(J)';
        F = forest(x,y,10);

        xVal = xTrFlower(:,K,i);
        yVal = c(K)';
    else
        x = xTrFlowerF(:,J,i-4);
        y = c(J)';
        F = forest(x,y,10);

        xVal = xTrFlowerF(:,K,i-4);
        yVal = c(K)';      
    end;

    preds = evalforest(F,xVal);
    correctFFlower(i) = sum(yVal == preds)/size(preds,2);
end

save('accuracy.mat', 'correctFFlower', '-append');