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
    EURUSD_pre = loadDataCsv('EURUSD_tick.csv',sys_par);
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
% insample
EURUSD_pre_is = partition('in',EURUSD_pre,sys_par);
EURUSD_t1_is = partition('in',EURUSD_t1,sys_par);
EURUSD_t2_is = partition('in',EURUSD_t2,sys_par);
% outsample
EURUSD_pre_os = partition('out',EURUSD_pre,sys_par);
EURUSD_t1_os = partition('out',EURUSD_t1,sys_par);
EURUSD_t2_os = partition('out',EURUSD_t2,sys_par);

% optimization
xinit = [10,10,0.5,2]';
addpath('./optimize/');
[isObj,par,counteval,stopflag,out,bestever] = ...
    CMAoptim('optim',xinit,[],optimStruct,EURUSD_pre_is,EURUSD_t1_is,EURUSD_t2_is,sys_par);

% out of sample run
[osObj,osTradingTable,osDailyTT] = optim(bestever.x,EURUSD_pre_os,EURUSD_t1_os,EURUSD_t2_os,sys_par);

