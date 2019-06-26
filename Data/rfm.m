function [L] = rfm(A, s, sigma)

% cpusmall: sigma=0.75
% MSD: sigma = 3101.6

[n, d] = size(A);

W = randn(d, s) / sigma;
v = rand(1, s) * 2 * pi;
L = A * W;
L = bsxfun(@plus, L, v);
L = cos(L) * sqrt(2 / s);

end

