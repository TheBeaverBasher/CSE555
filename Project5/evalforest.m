function preds=evalforest(F,xTe)
% function preds=evalforest(F,xTe);
%
% Evaluates a random forest on a test set xTe.
%
% input:
% F   | Forest of decision trees
% xTe | matrix of m input vectors (matrix size dxm)
%
% output:
%
% preds | predictions of labels for xTe
%

%% fill in code here

[~ ,n] = size(xTe);
[~, ~, nt] = size(F);

tempPreds = zeros(nt,n);

for i = 1:nt
   tempPreds(i,:) = evaltree(F(:,:,i),xTe); 
end

preds = mode(tempPreds);


