clear all
load('sepDataFruit.mat');

yTrFruit = horzcat(yTrFruit);
yTrFruit=yTrFruit(~cellfun('isempty',yTrFruit));
yTrFruit = reshape(yTrFruit, [4,size(xTrFruit,2)]);

[a, b, c] = unique(yTrFruit(2,:), 'stable');

correctFFruit = zeros(1,6);

n = size(c,1);

I = randsample(1:n,n);
J = I(1:round(.9*n));
K = I(round(.9*n)+1:end);

for i = 1:6
    if i < 5
        x = xTrFruit(:,J,i);
        y = c(J)';
        FFruit = forest(x,y,10);

        xVal = xTrFruit(:,K,i);
        yVal = c(K)';
    else
        x = xTrFruitF(:,J,i-4);
        y = c(J)';
        FFruit = forest(x,y,10);

        xVal = xTrFruitF(:,K,i-4);
        yVal = c(K)';      
    end;

    preds = evalforest(FFruit,xVal);
    correctFFruit(i) = sum(yVal == preds)/size(preds,2);
end

save('accuracy.mat', 'correctFFruit', 'FFruit', '-append');