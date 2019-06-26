function [Asketch, bsketch] = countsketch(A, b, s)

[n, d] = size(A);
sgn = randi(2, n, 1) * 2 - 3; % one half are +1 and the rest are -1
indices = randsample(s, n, true); % sample n items from [s] with replacement

A = bsxfun(@times, A, sgn); % flip the signs of each column w.p. 50%
b = b .* sgn;
Asketch = zeros(s, d);
bsketch = zeros(s, 1);

for j = 1: n
    Asketch(indices(j), :) = Asketch(indices(j), :) + A(j, :);
end

for j = 1: n
    bsketch(indices(j)) = bsketch(indices(j)) + b(j);
end

end