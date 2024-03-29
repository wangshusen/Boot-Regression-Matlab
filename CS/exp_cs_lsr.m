function exp_cs_lsr(filename, sketch)
% input
% A: n-by-d1 matrix where n >> d
% sketch: either 'gaussian' or 'srht' or 'sampling'


load(filename);
dataname = filename(1:2)
[n, d] = size(A);


% ------------------- Parameters ------------------- %
numBoot = 20;  %%%%%%%%%%%%% can be tuned
numRepeat = 1000;  %%%%%%%%%%%%% can be tuned
tList = ceil([10*d : d: 30*d]);%%%%%%%%%%%%% real data
tMax = max(tList);

% ------------------- Precompute ------------------- %
numT = length(tList);
d = size(A, 2);
outputFileName = ['result_', dataname, '_', sketch '.mat'];
resultEmpiricalL2 = zeros(numRepeat, numT);
resultEmpiricalInfty = zeros(numRepeat, numT);
resultBootL2 = zeros(numRepeat, numT, numBoot);
resultBootInfty = zeros(numRepeat, numT, numBoot);
wopt = A \ b;



for r = 1: numRepeat
    r
    [ASketchMax, bSketchMax] = sketching(A, b, tMax, sketch);
    
    % matrix multiplication errors
    for i = 1: numT
        t = tList(i);
        AS = ASketchMax(1:t, :);
        bS = bSketchMax(1:t, :);
        wS = AS \ bS;
        res = (wS - wopt);
        %res = A * (wS - wopt);
        errL2 = norm(res);
        errInfty = max(abs(res));
        resultEmpiricalL2(r, i) = errL2;
        resultEmpiricalInfty(r, i) = errInfty;
    end
    
    % bootstrap errors
    for i = 1: 2 %numT
        t = tList(i);
        AS = ASketchMax(1:t, :);
        bS = bSketchMax(1:t, :);
        wS = AS \ bS;
        
        for boot = 1: numBoot
            idx = randsample(t, t, true);
            Atilde = AS(idx, :);
            btilde = bS(idx, :);
            wtilde = Atilde \ btilde;
            res = (wS - wtilde);
            %res = A * (wS - wtilde);
            resultBootL2(r, i, boot) = norm(res);
            resultBootInfty(r, i, boot) = max(abs(res));
        end
    end
end


save(outputFileName, 'd', 'tList', 'resultEmpiricalL2', 'resultBootL2', 'resultEmpiricalInfty', 'resultBootInfty');


end


