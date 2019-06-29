function [results] = cv(A, b, n_train)

repeat = 100;
lambdas = [1E-3; 1E-2; 1E-1; 1E0; 1E1; 1E2; 1E3];

errors = zeros(length(lambdas), repeat);

for r = 1: repeat
    err = evaluate(A, b, n_train, lambdas);
    errors(:, r) = err;
end

errors = median(errors, 2);

results = [errors, lambdas];

end


function [errors] = evaluate(A, b, n_train, lambdas)

[n, d] = size(A);
randidx = randperm(n);
A = A(randidx, :);
b = b(randidx);
A_test = A(n_train+1:end, :);
b_test = b(n_train+1:end);
A_train = A(1:n_train, :);
b_train = b(1:n_train, :);

l = length(lambdas);
errors = zeros(l, 1);
for i = 1: l
    lam = lambdas(i);
    w = ridge(A_train, b_train, lam);
    b_pred = A_test * w;
    err = b_pred - b_test;
    errors(i) = mean(err .* err);
end

end


function [w] = ridge(A, b, lam)
[n, d] = size(A);
AA = A' * A;
Ab = A' * b;
w = (AA + lam * eye(d)) \ Ab;
end