%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            Optimization
%
% Authors:          Daniel Waelchli, Mike Schwitalla
% Date:             January 2016
% Version:          2.00
%
% Description:      main engine,
%                   function collection in ./func/
%                   indicator functions in ./indicators/
%                   optimizer in ./DE/
%                   objective functions in ./obj/
%                   plot functions in ./plotfunc/
%                   saved plots in ./plot/
%                   data in ./dat/
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% setup
setup();
% system parameter
sys_par = getSysPar();
% optim parameter
optimStruct = getOptimPar();

% try load
try
    clear EURUSD
    EURUSD = load('./dat/EURUSD.mat');
    EURUSD_pre = EURUSD.EURUSD_pre;
    EURUSD_t1 = EURUSD.EURUSD_t1;
    EURUSD_t2 = EURUSD.EURUSD_t2;
catch   
    % load & process data
    EURUSD_pre = loadDataCsv('EURUSD_tick_3M.csv',sys_par);
    EURUSD_t1 = compress(EURUSD_pre,15,sys_par,'bid','ask');
    EURUSD_t2 = compress(EURUSD_pre,60,sys_par,'bid','ask');
    
    % function handles to precomputed indicators
    fSdev = @(DS,i,t) sdev(DS,i,t);
    
    % append indicator values
    EURUSD_t1 = appendIndicator(EURUSD_t1,sys_par,'sdev',fSdev,50);
    EURUSD_t2 = appendIndicator(EURUSD_t2,sys_par,'sdev',fSdev,50);
    
    % save dataset
    save './dat/EURUSD1560.mat' EURUSD_pre EURUSD_t1 EURUSD_t2 
end

%% partitioning
% t1
dataParti_t1 = partition(EURUSD_pre,EURUSD_t1,sys_par);
% t2
dataParti_t2 = partition(EURUSD_pre,EURUSD_t2,sys_par);
%%
% optimization
addpath('./optimize/');
[isObj,par,counteval,stopflag,out,bestever] = ...
    CMAoptim('optim',optimStruct.xinit,[],optimStruct,dataParti_t1.preIs,dataParti_t1.tIs,dataParti_t2.tIs,sys_par);

% out of sample run
[osObj,osTradingTable,osDailyTT] = optim(bestever.x,dataParti_t1.preOs,dataParti_t1.tOs,dataParti_t2.tOs,sys_par);

