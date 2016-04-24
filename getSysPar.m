function [sys_par] = getSysPar()


%% File names
% DEoptim result file name
sys_par.fileName = './dat/Stoch_optim.csv';

%% Objective Function
% Use Daily Optimisation
sys_par.daily_optim = true;
% use functions from ./obj/ folder
% Daily Optimisation
sys_par.obj_func = 'sharpeRatio'; %Or 'sortino'
% Intraday Optimisation
sys_par.obj_func_intra = 'morereturnobjvs2'; %Or 'profitfactor', 'maxdrawdown'
sys_par.alpha=1.999999; %alpha  preference scalar for own objective function
% Define which trading system is used
possibleSelections = {'MAFix', 'MAFlex', 'RSIFix', 'RSIFlex'}; %add further trading systems here
strSystems = [];
for ii=1:length(possibleSelections)
    strSystems = [strSystems,' ', possibleSelections{ii}];
end
correctInput = 0;
while true
    str = input(['Select and typewrite trading system:',strSystems,': \n '],'s');
    for ii = 1:length(possibleSelections)
        if strcmp(possibleSelections{ii},str);
            correctInput = 1;
            sys_par.sysName = str;
        end
    end
    if correctInput;
        break;
    else
        disp('Invalid trading system selection')
    end
end
disp(['Trading system ',str,' selected'])


%% Trading Parameters
% initial equity
sys_par.equityInit = 100000;
% comission per trade
sys_par.comission = 0.5*8/100000;
% warm up time
sys_par.tInit = 100;

sys_par.minTradesPerDay = 1;
sys_par.maxTradesPerDay = 60;

%% Parameters to optimize
switch(sys_par.sysName)
    case 'MAFix'
        % trading system function
        sys_par.tradingSystem = 'optimintradayMAFix';
        % initial guess parameter vector: [x,y,tp,sl]'
        % x:    length of moving average filter of short filter
        % x+y:  length of moving average filter of long filter
        % tp:   take profit factor
        % sl:   stop loss factor
        sys_par.xinit = [10 10 0.03 0.03]'; 
        % number of params to optimize, dims of x
        sys_par.dim = length(sys_par.xinit);
        % lower bounds
        sys_par.LBounds = [4 3 1e-3 1e-3]';
        % upper bounds
        sys_par.UBounds = [50 50 0.05 0.03]'; 
        % integer optimization
        % 0 continuous, x>0 step size (0.2 searches .., -0.2, 0, 0.2, 0.4, ..)
        sys_par.StairWidths = [1 1 0 0];
    case 'MAFlex'
        % trading system function
        sys_par.tradingSystem = 'optimintradayMAFlex';
        % initial guess parameter vector: [k1,k2,nBB,x,y]'
        % k1:   constant for calculating bollinger bands of take profit
        % k2:   constant for calculating bollinger bands of stop loss
        % nBB:    window size bollinger bands are calculated
        % x:    length of moving average filter of short filter
        % x+y:  length of moving average filter of long filter
        sys_par.xinit =         [1 1 20 5 50]';
        % number of params to optimize, dims of x
        sys_par.dim = length(sys_par.xinit);
        % lower bounds
        sys_par.LBounds =       [0 0 1 1 0]';
        % upper bounds
        sys_par.UBounds =       [5 5 100 50 50]'; 
        % integer optimization
        % 0 continuous, x>0 step size (0.2 searches .., -0.2, 0, 0.2, 0.4, ..)
        sys_par.StairWidths =   [0 0 1 1 1];
    case 'RSIFix'
        % trading system function
        sys_par.tradingSystem = 'optimintradayRSIFix';
        % initial guess parameter vector: [nRSI,tp,sl]'
        % nRSI: window size RSI is calculated
        % tp:   take profit factor
        % sl:   stop loss factor
        sys_par.xinit =         [20 0.03 0.03]';
        % number of params to optimize, dims of x
        sys_par.dim = length(sys_par.xinit);
        % lower bounds
        sys_par.LBounds =       [1 1e-3 1e-3]';
        % upper bounds
        sys_par.UBounds =       [90 0.99 0.05]'; 
        % integer optimization
        % 0 continuous, x>0 step size (0.2 searches .., -0.2, 0, 0.2, 0.4, ..)
        sys_par.StairWidths =   [1 0 0];
    case 'RSIFlex'
        % trading system function
        sys_par.tradingSystem = 'optimintradayRSIFlex';
        % initial guess parameter vector: [nRSI k1 k2 nBB]'
        % nRSI: window size RSI is calculated
        % k1:   constant for calculating bollinger bands of take profit
        % k2:   constant for calculating bollinger bands of stop loss
        % nBB:  window size bollinger bands are calculated
        sys_par.xinit =         [20 1 20 20]';
        % number of params to optimize, dims of x
        sys_par.dim = length(sys_par.xinit);
        % lower bounds
        sys_par.LBounds =       [1 0 0 1]';
        % upper bounds
        sys_par.UBounds =       [90 5 5 100]'; 
        % integer optimization
        % 0 continuous, x>0 step size (0.2 searches .., -0.2, 0, 0.2, 0.4, ..)
        sys_par.StairWidths =   [1 0 0 1];
    otherwise
        disp('Error. No valid trading system slected!')
        return
end


%% Partitioning
% percentage of data used in opimization
sys_par.insamplePCT = 0.4;

%% MISC
% allow program output to command window
sys_par.echo = false;


%% For automation
sys_par.underlying = {'EURUSD'}; %underlying (string)
% sys_par.underlying = {'AUDUSD';'EURUSD';'GBPUSD';'NZDUSD';'USDCAD';'USDCHF';'USDJPY';'USDNOK';'USDSEK'; 'BRENTCMDUSD'; 'JPNIDXJPY'}; %%%%Ohne Weekend multiple
sys_par.lengthData = 24; %length of tick data (months)
sys_par.tVec = [12;480]; %time steps tick data is compressed to (min)

%underlying = {'USDJPY'; 'EURUSD'; 'EURNOK'; 'EURSEK'}
%underlying = {'EURUSD';'USDJPY';'AUDUSD';'GBPUSD';'NZDUSD';'USDCAD';'USDCHF'}; %cell array Majors
%underlying = {'AUDCAD';'AUDJPY';'AUDNZD';'EURAUD';'EURGBP';'EURJPY';'EURCAD';'EURNOK';'EURSEK';'EURNZD';'GBPCHF';'GBPJPY';'CADJPY';'GBPAUD';'GBPCAD';'GBPNZD';'USDCNH';'NZDCAD';'NZDJPY'}; %Minors
%underlying = {'USDZAR';'USDTRY';'USDMXN';'EURPLN';}; %Exotics
%underlying = {'BRENTCMDUSD';'XAGUSD';'XAUUSD'}%;'CUCMDUSD';'PDCMDUSD';'PTCMDUSD'}; %COMMODITIES
%underlying = {'USA500IDXUSD';'USATECHIDXUSD';'CHEIDXCHF';'DEUIDXEUR'}; %INDICES
%underlying = {'EURUSD';'USDJPY';'AUDUSD';'GBPUSD';'NZDUSD';'USDCAD';'USDCHF';'AUDCAD';'AUDJPY';'AUDNZD';'EURAUD';'EURGBP';'EURJPY';'EURCAD';'EURNOK';'EURSEK';'EURNZD';'GBPCHF';'GBPJPY';'CADJPY';'GBPAUD';'GBPCAD';'GBPNZD';'USDCNH';'NZDCAD';'NZDJPY';'USDZAR';'USDTRY';'USDMXN';'EURPLN';'BRENTCMDUSD';'XAGUSD';'XAUUSD';'USA500IDXUSD';'USATECHIDXUSD';'CHEIDXCHF';'DEUIDXEUR'};
end

