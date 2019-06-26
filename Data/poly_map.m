function [C] = poly_map(A)

[n, d] = size(A);
m = d * (d + 1) / 2;
B = zeros(n, m);

l = 1;
for i = 1: d
    for j = 1: i
        B(:, l) = A(:, i) .* A(:, j);
        l = l + 1;
    end
end

Bnorms = max(abs(B));
normalizer = 1 ./ Bnorms;
B = bsxfun(@times, B, reshape(normalizer, 1, m));

C = [A, B];

end

