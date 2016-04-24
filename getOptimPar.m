function [opts] = getOptimPar(sys_par)

flag_parallel = true;

%% Parameters
% initial guess
opts.xinit = sys_par.xinit;

% number of params to optimize, dims of x
opts.dim = sys_par.dim;

% lower bounds
opts.LBounds = sys_par.LBounds;

% upper bounds
opts.UBounds = sys_par.UBounds; 

% integer optimization
% 0 continuous, x>0 step size (0.2 searches .., -0.2, 0, 0.2, 0.4, ..)

opts.StairWidths = sys_par.StairWidths;

%% CMA-ES Options
% folder to place results
data_folder = './dat/';
% OPTS.CMA.active = 1 turns on "active CMA" with a negative update 
% of the covariance matrix and checks for positive definiteness. 
% OPTS.CMA.active = 2 does not check for pos. def. and is numerically
% faster.
opts.CMA.active = 0;
% number of samples per stage
opts.PopSize = 10*opts.dim;
% restart on/off
opts.Resume = 0;
% max objective fun evaluations
% (other Stopping options StopFunEvals, StopIter, MaxFunEvals, Fitness)
opts.MaxFunEvals = 4e2;
% In case of a noisy objective function set opts.Noise.on = 1. 
% termination criteria, because the step-size sigma will not converge to zero
opts.Noise.on = 0;
% To run silently set Disp, Save, and Log options to 0.  
% With opts.LogModulo > 0 (1 by default) the most important
% data are written (When opts.SaveVariables==1  everything is saved)
opts.LogModulo = 1;
opts.SaveVariables = 1;
% plot while running using output data files
opts.LogPlot = 0;
% objective function FUN accepts NxM matrix, with M>1?';
opts.EvalParallel = flag_parallel;
% evaluation of initial solution;
opts.EvalInitialX = 1;
% stop if x-change smaller TolX'
opts.TolX = 1e-4;
% stop if equal function values happen in more than 33%
opts.StopOnEqualFunctionValues = 0;
opts.SaveFilename = [ data_folder 'results_cma_optimization.mat'];
opts.LogFilenamePrefix = [ data_folder 'outcmaes_results_optimization_'];

%% Differential Evolution Options
% turn parallel optimization on/off
opts.enable_parallel = flag_parallel;
% number of workers/genes
opts.nPopulation = 30;
% number of iterations
opts.maxIter = 100;
% crossover rate [0,1]
opts.CR = 0.7;
% differential weight [0,2]
opts.F = 1.5;
% number cpu's to be used
opts.N_cpu = 2;
% seed for random generator
opts.seed = 8392;



end


