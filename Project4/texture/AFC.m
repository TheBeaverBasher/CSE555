function Dpp = AFC(Dp, alpha, p)

% Higher p favors multiple good transitions; lower p favors a single poorer one
%
% alpha is used to control the relative weight of future transitions in the
% metric (0 < alpha < 1)

l = size(Dp, 1);
Dpp = zeros(l);

% prob=@(dist,sigma)  exp(-dist/sigma);

for i = l:-1:1
    for j = l:-1:1
        Dpp(i,j) = Dp(i,j)^p + alpha*min(Dpp(j,:));
    end;
end;
