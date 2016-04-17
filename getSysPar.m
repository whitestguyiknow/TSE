function [sys_par] = getSysPar()


%% File names
% DEoptim result file name
sys_par.fileName = './dat/Stoch_optim.csv';

%% Objective Function
% use functions from ./obj/ folder
%Daily Optimisation
sys_par.obj_func = 'sharpeRatio'; %Or 'sortino'
%Intraday Optimisation
sys_par.obj_func_intra = 'morereturnobj'; %Or 'profitfactor', 'maxdrawdown'

%% Trading Parameters
% initial equity
sys_par.equityInit = 100000;
% comission per trade
sys_par.comission = 0.5*8/100000;
% warm up time
sys_par.tInit = 100;
% min mean trades per day
sys_par.minTradesPerDay = 1;
% max mean trades per day
sys_par.maxTradesPerDay = 30;

%% Partitioning
% percentage of data used in opimization
sys_par.insamplePCT = 0.7;

%% MISC
% allow program output to command window
sys_par.echo = false;

%% For automation
sys_par.underlying = {'EURUSD'}; %underlying (string)
%sys_par.underlying = {'AUDUSD';'EURUSD';'GBPUSD';'NZDUSD';'USDCAD';'USDCHF';'USDJPY';'USDNOK';'USDSEK'; 'BRENTCMDUSD'; 'JPNIDXJPY'}; %%%%Ohne Weekend multiple
sys_par.lengthData = 24; %length of tick data (months)
sys_par.tVec = [12;480]; %time steps tick data is compressed to (min)
sys_par.sysName = 'xy';
%underlying = {'USDJPY'; 'EURUSD'; 'EURNOK'; 'EURSEK'}
%underlying = {'EURUSD';'USDJPY';'AUDUSD';'GBPUSD';'NZDUSD';'USDCAD';'USDCHF'}; %cell array Majors
%underlying = {'AUDCAD';'AUDJPY';'AUDNZD';'EURAUD';'EURGBP';'EURJPY';'EURCAD';'EURNOK';'EURSEK';'EURNZD';'GBPCHF';'GBPJPY';'CADJPY';'GBPAUD';'GBPCAD';'GBPNZD';'USDCNH';'NZDCAD';'NZDJPY'}; %Minors
%underlying = {'USDZAR';'USDTRY';'USDMXN';'EURPLN';}; %Exotics
%underlying = {'BRENTCMDUSD';'XAGUSD';'XAUUSD'}%;'CUCMDUSD';'PDCMDUSD';'PTCMDUSD'}; %COMMODITIES
%underlying = {'USA500IDXUSD';'USATECHIDXUSD';'CHEIDXCHF';'DEUIDXEUR'}; %INDICES
%underlying = {'EURUSD';'USDJPY';'AUDUSD';'GBPUSD';'NZDUSD';'USDCAD';'USDCHF';'AUDCAD';'AUDJPY';'AUDNZD';'EURAUD';'EURGBP';'EURJPY';'EURCAD';'EURNOK';'EURSEK';'EURNZD';'GBPCHF';'GBPJPY';'CADJPY';'GBPAUD';'GBPCAD';'GBPNZD';'USDCNH';'NZDCAD';'NZDJPY';'USDZAR';'USDTRY';'USDMXN';'EURPLN';'BRENTCMDUSD';'XAGUSD';'XAUUSD';'USA500IDXUSD';'USATECHIDXUSD';'CHEIDXCHF';'DEUIDXEUR'};
end

