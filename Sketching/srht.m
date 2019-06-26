function [Asketch, bsketch] = srht(A, b, s)

n = size(A, 1);
sgn = randi(2, [n, 1]) * 2 - 3; % one half are +1 and the rest are -1
A = bsxfun(@times, A, sgn); % flip the signs of each row w.p. 50%
b = bsxfun(@times, b, sgn); % flip the signs of each row w.p. 50%
npower = 2^(ceil(log2(n))); 
A2 = (fwht(A, npower)) * sqrt(npower); % Hadarmard transform
b2 = (fwht(b, npower)) * sqrt(npower); % Hadarmard transform
S = randsample(npower, s, true);
Asketch = A2(S, :) * sqrt(npower / s);
bsketch = b2(S, :) * sqrt(npower / s);



end


