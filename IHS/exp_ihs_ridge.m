function exp_ihs_ridge(filename, sketch, s, numBoot)
% input
% A: n-by-d1 matrix where n >> d
% sketch: either 'gaussian' or 'srht' or 'sampling'


load(filename);
dataname = filename(1:2);
[n, d] = size(A);

lam = 1; % cpusmall and msd

A = [A; eye(d) * sqrt(lam)];
b = [b; zeros(d, 1)];

% ------------------- Parameters ------------------- %
tMax = 10; %%%%%%%%%%%%% number of iterations, can be tuned
numRepeat = 1000; %%%%%%%%%%%%% number of repeats, can be tuned
empirical = zeros(tMax, numRepeat);
boot99 = zeros(tMax, numRepeat);
boot95 = zeros(tMax, numRepeat);
boot50 = zeros(tMax, numRepeat);
coverage99 = zeros(tMax, numRepeat);
coverage95 = zeros(tMax, numRepeat);
coverage50 = zeros(tMax, numRepeat);


% ------------------- Precompute ------------------- %
ab = A' * b;
wopt = A \ b;
outputFileName = ['ihs_', dataname, '_', sketch , '_', int2str(s), '.mat'];



% ------------------- Algorithm ------------------- %

for r = 1: numRepeat
    r
    %[Asketch, ~] = sketching(A, b, s, sketch);
    %Hsketch = Asketch' * Asketch;
    w = zeros(d, 1);

    % t indexes the iterations
    for t = 1: tMax
        g = A' * (A * w) - ab;
        %gnorm = norm(g);
        [Asketch, ~] = sketching(A, b, s, sketch);
        Hsketch = Asketch' * Asketch;
        p = Hsketch \ g;
        w = w - p;

        empirical(t, r) = norm(w - wopt);


        % bootstrap
        boot = zeros(numBoot, 1);
        for b = 1: numBoot
            idx = randsample(s, s, true);
            Atilde = Asketch(idx, :);
            Htilde = Atilde' * Atilde;
            %gtilde = Asketch' * (Asketch * w) - ab;
            %ptilde = Htilde \ gtilde;
            ptilde = Htilde \ g;
            boot(b) = norm(p - ptilde);
        end
        
        if t > 3
            continue;
        end
        
        coverage99(t, r) = (quantile(boot, 0.99) > empirical(t, r));
        coverage95(t, r) = (quantile(boot, 0.95) > empirical(t, r));
        coverage50(t, r) = (quantile(boot, 0.50) > empirical(t, r));
        boot99(t, r) = quantile(boot, 0.99);
        boot95(t, r) = quantile(boot, 0.95);
        boot50(t, r) = quantile(boot, 0.50);
    end
end

empirical99 = quantile(empirical, 0.99, 2);
empirical95 = quantile(empirical, 0.95, 2);
empirical50 = quantile(empirical, 0.50, 2);
coverage99 = mean(coverage99, 2);
coverage95 = mean(coverage95, 2);
coverage50 = mean(coverage50, 2);


tList = 1: tMax;
save(outputFileName, 's', 'd', 'tList', 'empirical', 'empirical99', 'empirical95', 'empirical50', 'boot99', 'boot95', 'boot50', 'coverage99', 'coverage95', 'coverage50');


end





