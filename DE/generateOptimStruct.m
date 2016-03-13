function [S] = generateOptimStruct()
S.enable_parallel = true;
S.nPopulation = 30;
S.maxIter = 100;
S.CR = 0.7;
S.F = 1.5;
S.N_cpu = 2;
S.seed = 8392;
end

