function [opts] = getOptimPar()
opts.dim = 3;

opts.LBounds = [3 0.1 0.1]';    % lower bound
opts.UBounds = [40 15 15]';     % upper bound

%% Differential Evolution Options
opts.enable_parallel = true;
opts.nPopulation = 30;
opts.maxIter = 100;
opts.CR = 0.7;
opts.F = 1.5;
opts.N_cpu = 2;
opts.seed = 8392;

%% CMA-ES Options
data_folder = './dat/';
opts.CMA.active = 0;
opts.PopSize = 40;
opts.Resume = 0;
opts.MaxFunEvals = 1e4;
opts.Noise.on = 0; 
opts.LogModulo = 1;
opts.LogPlot = 1;
opts.EvalParallel = 1;
opts.EvalInitialX = 1;
opts.TolX = 1e-8;
opts.StopOnEqualFunctionValues = 0;
opts.SaveFilename = [ data_folder 'results_cma_optimization.mat'];
opts.LogFilenamePrefix = [ data_folder 'outcmaes_results_optimization_'];

end


