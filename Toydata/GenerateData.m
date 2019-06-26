function [X, w, y] = GenerateData(n, d, type)

covMatrix = GenerateCovMatrix(d);

if strcmp(type, 'UG') || strcmp(type, 'UB')
    U = orth(mvnrnd(ones(n, d), covMatrix));
elseif strcmp(type, 'NG') || strcmp(type, 'NB')
    v = 2; % degree of freedom
    U = orth(mvtrnd(covMatrix, v, n));
end

if strcmp(type, 'UG') || strcmp(type, 'NG')
    singularvalues = linspace (1 , 1e-1, d);
elseif strcmp(type, 'UB') || strcmp(type, 'NB')
    singularvalues = logspace(0, -3, d);
end

X = U * diag(singularvalues) * orth(randn(d));

d1 = ceil(d * 0.2);
d2 = d - d1 * 2;
w = [ones(d1, 1); ones(d2, 1) * 0.1; ones(d1, 1)];
xi = 1E-3; % noise lever; can be tuned
y = X * w + randn(n, 1) * xi;

end


function [covMatrix] = GenerateCovMatrix(p)
covMatrix = zeros(p);
for i = 1: p
    for j = 1: p
        covMatrix(i, j) = 2 * 0.5^(abs(i-j));
    end
end
end