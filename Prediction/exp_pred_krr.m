function exp_pred_krr(filename, sketch, sigma, s, lam)
% input
% A: n-by-d1 matrix where n >> d
% sketch: either 'gaussian' or 'srht' or 'sampling'


load(filename);
dataname = filename(1:2)
[n, d] = size(A);

% random feature mapping
A = rfm(A, d*s, sigma); 
[n, d] = size(A);

% partition to training and test sets
randidx = randperm(n);
A = A(randidx, :);
b = b(randidx);
n_train = ceil(n / 2.0);
A_test = A(n_train+1:end, :);
b_test = b(n_train+1:end);
A = A(1:n_train, :);
b = b(1:n_train, :);



A = [A; eye(d) * sqrt(lam)];
b = [b; zeros(d, 1)];


% ------------------- Parameters ------------------- %
numBoot = 20;  %%%%%%%%%%%%% can be tuned
numRepeat = 1000;  %%%%%%%%%%%%% can be tuned
tList = ceil([10*d : d: 30*d]);%%%%%%%%%%%%% real data
tMax = max(tList);


% ------------------- Precompute ------------------- %
numT = length(tList);
d = size(A, 2);
outputFileName = ['pred_', dataname, '_', sketch, '_', int2str(s), '.mat'];
resultEmpiricalL2 = zeros(numRepeat, numT);
resultEmpiricalInfty = zeros(numRepeat, numT);
resultBootL2 = zeros(numRepeat, numT, numBoot);
resultBootInfty = zeros(numRepeat, numT, numBoot);
wopt = A \ b;



for r = 1: numRepeat
    r
    [ASketchMax, bSketchMax] = sketching(A, b, tMax, sketch);
    
    % empirical errors
    for i = 1: numT
        t = tList(i);
        AS = ASketchMax(1:t, :);
        bS = bSketchMax(1:t, :);
        wS = AS \ bS;
        res = A_test * (wS - wopt);
        errL2 = norm(res);
        errInfty = max(abs(res));
        resultEmpiricalL2(r, i) = errL2;
        resultEmpiricalInfty(r, i) = errInfty;
    end
    
    % bootstrap errors
    for i = 1: 2%numT
        t = tList(i);
        AS = ASketchMax(1:t, :);
        bS = bSketchMax(1:t, :);
        wS = AS \ bS;
        
        for boot = 1: numBoot
            idx = randsample(t, t, true);
            Atilde = AS(idx, :);
            btilde = bS(idx, :);
            wtilde = Atilde \ btilde;
            res = A_test * (wS - wtilde);
            resultBootL2(r, i, boot) = norm(res);
            resultBootInfty(r, i, boot) = max(abs(res));
        end
    end
end


save(outputFileName, 'd', 'tList', 'resultEmpiricalL2', 'resultBootL2', 'resultEmpiricalInfty', 'resultBootInfty');


end


