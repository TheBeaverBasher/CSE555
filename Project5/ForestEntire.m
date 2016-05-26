clear all
load('sepDataEntire.mat');

yTrEntire = horzcat(yTrEntire);
yTrEntire=yTrEntire(~cellfun('isempty',yTrEntire));
yTrEntire = reshape(yTrEntire, [4,size(xTrEntire,2)]);

[a, b, c] = unique(yTrEntire(2,:), 'stable');

correctFEntire = zeros(1,6);

n = size(c,1);

I = randsample(1:n,n);
J = I(1:round(.9*n));
K = I(round(.9*n)+1:end);

for i = 1:6
    if i < 5
        x = xTrEntire(:,J,i);
        y = c(J)';
        F = forest(x,y,10);

        xVal = xTrEntire(:,K,i);
        yVal = c(K)';
    else
        x = xTrEntireF(:,J,i-4);
        y = c(J)';
        F = forest(x,y,10);

        xVal = xTrEntireF(:,K,i-4);
        yVal = c(K)';      
    end;

    preds = evalforest(F,xVal);
    correctFEntire(i) = sum(yVal == preds)/size(preds,2);
end

save('accuracy.mat', 'correctFEntire', '-append');