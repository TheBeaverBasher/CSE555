clear all
load('sepDataStem.mat');

yTrStem = horzcat(yTrStem);
yTrStem=yTrStem(~cellfun('isempty',yTrStem));
yTrStem = reshape(yTrStem, [4,size(xTrStem,2)]);

[a, b, c] = unique(yTrStem(2,:), 'stable');

correctFStem = zeros(1,6);

n = size(c,1);

I = randsample(1:n,n);
J = I(1:round(.9*n));
K = I(round(.9*n)+1:end);

for i = 1:1
    if i < 5
        x = xTrStem(:,J,i);
        y = c(J)';
        F = forest(x,y,10);

        xVal = xTrStem(:,K,i);
        yVal = c(K)';
    else
        x = xTrStemF(:,J,i-4);
        y = c(J)';
        F = forest(x,y,10);

        xVal = xTrStemF(:,K,i-4);
        yVal = c(K)';      
    end;

    preds = evalforest(F,xVal);
    correctFStem(i) = sum(yVal == preds)/size(preds,2);
end

save('accuracy.mat', 'correctFStem', 'F', '-append');