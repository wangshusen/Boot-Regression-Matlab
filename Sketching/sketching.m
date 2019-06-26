function [Asketch, bsketch] = sketching(A, b, s, sketch)
n = size(A, 1);

if strcmp(sketch, 'gaussian')
    S = randn(s, n);
    Asketch = S * A / sqrt(s);
    bsketch = S * b / sqrt(s);
elseif strcmp(sketch, 'srht')
    [Asketch, bsketch] = srht(A, b, s);
elseif strcmp(sketch, 'srft')
    [Asketch, bsketch] = srft(A, b, s);
elseif strcmp(sketch, 'count')
    [Asketch, bsketch] = countsketch(A, b, s);
elseif strcmp(sketch, 'sampling')
    prob = sum(A.^2, 2);
    prob = prob / sum(prob);
    S = randsample(n, s, true, prob);
    Asketch = bsxfun(@times, A(S, :), 1 ./ sqrt(prob(S, :))) / sqrt(s);
    bsketch = bsxfun(@times, b(S, :), 1 ./ sqrt(prob(S, :))) / sqrt(s);
elseif strcmp(sketch, 'uniform')
    S = randsample(n, s);
    Asketch = A(S, :) * sqrt(n / s);
    bsketch = b(S, :) * sqrt(n / s);
end
end