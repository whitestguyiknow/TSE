function [sys_par] = getSysPar()


%% File names
% DEoptim result file name
sys_par.fileName = './dat/Stoch_optim.csv';

%% Objective Function
% use functions from ./obj/ folder
%Daily Optimisation
sys_par.obj_func = 'sharpeRatio'; %Or 'sortino'
%Intraday Optimisation
sys_par.obj_func_intra

%% Trading Parameters
% initial equity
sys_par.equityInit = 100000;
% comission per trade
sys_par.comission = 0.5*8/100000;
% warm up time
sys_par.tInit = 100;

%% Partitioning
% percentage of data used in opimization
sys_par.insamplePCT = 0.7;

%% MISC
% allow program output to command window
sys_par.echo = false;
end

