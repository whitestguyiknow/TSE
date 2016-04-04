%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            Optimization
%
% Authors:          Daniel Waelchli, Mike Schwitalla
% Date:             January 2016
% Version:          2.00
%
% Description:      main engine Default 24 Month of data,
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
%%Initializing
% setup
setup();
% system parameter
sys_par = getSysPar();
% optim parameter
optimStruct = getOptimPar();




%% Data processing
% try load

try
    clear EURUSD
    EURUSD = load('./dat/EURUSD.mat');
    EURUSD_pre = EURUSD.EURUSD_pre;
    EURUSD_t1 = EURUSD.EURUSD_t1;
    EURUSD_t2 = EURUSD.EURUSD_t2;
catch
    %MS: Hier Automatisierung Kreation einfügen. Was bedeutet, dass hier
    %mit der Funktion generate Dataset gearbeitet werden muss
    %daher müssen in getSyspar noc 'SystemName', 'unterlying', t1, t2, definiert werden 
    % load & process data
    EURUSD_pre = loadDataCsv('USDJPY_tick_6M.csv',sys_par);
    EURUSD_t1 = compress(EURUSD_pre,15,sys_par,'bid','ask');
    EURUSD_t2 = compress(EURUSD_pre,60,sys_par,'bid','ask');
    
    % save dataset
    save './dat/EURUSD1560240.mat' EURUSD_pre EURUSD_t1 EURUSD_t2 
end

% function handles to precomputed, global indicators
  fSdev = @(DS,i,t) sdev(DS,i,t);% Standarddeviation of underlying of last t datapoints
  
% append indicator values
  EURUSD_t1 = appendIndicator(EURUSD_t1,sys_par,'sdev',fSdev,50);
  EURUSD_t2 = appendIndicator(EURUSD_t2,sys_par,'sdev',fSdev,50);

% partitioning
% insample
EURUSD_pre_is = partition('in',EURUSD_pre,sys_par);
EURUSD_t1_is = partition('in',EURUSD_t1,sys_par);
EURUSD_t2_is = partition('in',EURUSD_t2,sys_par);
% outsample
EURUSD_pre_oos = partition('out',EURUSD_pre,sys_par);
EURUSD_t1_oos = partition('out',EURUSD_t1,sys_par);
EURUSD_t2_oos = partition('out',EURUSD_t2,sys_par);

%% Setting entry and exit rules & optimization
%(entry and exit rules defind in optimintraday or optimdaily)
xinit = [5,1,1]'; %Initial Startpoint for CMA
addpath('./optimize/');
%Intraday Optimisation. (For Daily Optimisation use optimdaily instead of
%optimintraday
timeoptimstart=clock;

[obj,par,counteval,stopflag,out,bestever] = ...
    CMAoptim('optimintraday',xinit,[],optimStruct,EURUSD_pre_is,EURUSD_t1_is,EURUSD_t2_is,sys_par);

timeoptimend=clock;
evaltime= roundn(floor(etime(timeoptimend,timeoptimstart))/60,-1);
N_cpu=numlabs;
fprintf('Time used for optimisation: %.1f min with %.0f CPUs\n', evaltime,N_cpu);
%save bestever under: /dat/optresults/bestever_'SystemName'_'Underlying'_'Zeitintervall'.csv)

%% out and in of sample run of sample run
% Best Tradingparameter creation
LB = 10;
fBuyEntry = @(DS1,i,DS2,k) entryBuyStoch(DS1,i,DS2,k,LB,bestever.x(1));
fSellEntry = @(DS1,i,DS2,k) entrySellStoch(DS1,i,DS2,k,LB,bestever.x(1));
fBuyExit = @(DS1,i,DS2,k) exitBuyTrailingSDEV(DS1,i,DS2,k,bestever.x(2),bestever.x(3));
fSellExit = @(DS1,i,DS2,k) exitSellTrailingSDEV(DS1,i,DS2,k,bestever.x(2),bestever.x(3));

%insample run
usdkursis = ones(length(EURUSD_pre_is.time),1);
[isTime, isAction] = buildActionMatrix(EURUSD_t1_is,EURUSD_t2_is,fBuyEntry,fBuyExit,fSellEntry,fSellExit, sys_par);
isTradingTable = buildTradingTable(EURUSD_pre_is,isTime,isAction*100000,usdkursis,sys_par);
isDailyTT = buildDailyTradingTable(isTradingTable, sys_par);

%out of sample run
usdkursoos = ones(length(EURUSD_pre_oos.time),1);
[oosTime, oosAction] = buildActionMatrix(EURUSD_t1_oos,EURUSD_t2_oos,fBuyEntry,fBuyExit,fSellEntry,fSellExit, sys_par);
oosTradingTable = buildTradingTable(EURUSD_pre_oos,oosTime,oosAction*100000,usdkursoos,sys_par);
oosDailyTT = buildDailyTradingTable(oosTradingTable, sys_par);

save './dat/StochCMAinvsout.mat' isTradingTable isDailyTT oosTradingTable oosDailyTT; %(saved under: /dat/optresults/Trtables_'SystemName'_'Underlying'_'Zeitintervall'.mat)
clear all

%Loading results test
StochCMAinvsout = load('./dat/StochCMAinvsout.mat');
isTradingTable= StochCMAinvsout.isTradingTable;
isDailyTT= StochCMAinvsout.isDailyTT;
oosTradingTable= StochCMAinvsout.oosTradingTable;
oosDailyTT= StochCMAinvsout.oosDailyTT;

%%Performance Analytics
%Cumulative Return & Kernel Density Estimate of Return (saved under: /plots/invsout/invsout_'SystemName'_'Underlying'_'Zeitintervall'. eps and png)
plot_cumret_dens_invsout(isTradingTable.Return,oosTradingTable.Return)

%Boxplot Trading Hours (saved under: /plots/boxplots/boxplot_'SystemName'_'Underlying'_'Zeitintervall'.eps and png)


%Performance Analytics Table (saved under: /statistics/systems/perfan_'SystemName'_'Underlying'_'Zeitintervall'.csv)

