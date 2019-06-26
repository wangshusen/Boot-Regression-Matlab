function [A_new, b_new] = normalization(A, b)

[n, d] = size(A);
A_max = max(abs(A));
A_new = bsxfun(@times, A, 1 ./ A_max);

b_mean = mean(b);
b_new = b - b_mean;

end