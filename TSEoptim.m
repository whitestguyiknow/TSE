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
    EURUSD_pre = loadDataCsv('EURUSD_tick_6M.csv');
    EURUSD_t1 = compress(EURUSD_pre,15,'bid','ask');
    EURUSD_t2 = compress(EURUSD_pre,60,'bid','ask');
    
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
lp = length(EURUSD_pre); l1 = length(EURUSD_t1); l2 = length(EURUSD_t2);
EURUSD_pre_is = EURUSD_pre(1:ceil(lp*sys_par.insamplePCT),:);
EURUSD_t1_is = EURUSD_t1(1:ceil(l1*sys_par.insamplePCT),:);
EURUSD_t2_is = EURUSD_t2(1:ceil(l2*sys_par.insamplePCT),:);
% osample
EURUSD_pre_oos = EURUSD_pre(floor(lp*sys_par.insamplePCT):end,:);
EURUSD_t1_oos = EURUSD_t1(floor(l1*sys_par.insamplePCT):end,:);
EURUSD_t2_oos = EURUSD_t2(floor(l2*sys_par.insamplePCT):end,:);

% optimization
xinit = [5,1,1]';
addpath('./optimze/');
[obj,par,counteval,stopflag,out,bestever] = ...
    CMAoptim('optim',xinit,[],optimStruct,EURUSD_pre_is,EURUSD_t1_is,EURUSD_t2_is,sys_par);

% out of sample run
LB = 10;
fBuyEntry = @(DS1,i,DS2,k,DS3,l) entryBuyStoch(DS1,i,DS2,k,LB,bestever.x(1));
fSellEntry = @(DS1,i,DS2,k,DS3,l) entrySellStoch(DS1,i,DS2,k,LB,bestever.x(1));
fBuyExit = @(DS1,i,DS2,k) exitBuyTrailingSDEV(DS1,i,DS2,k,bestever.x(2),bestever.x(3));
fSellExit = @(DS1,i,DS2,k) exitSellTrailingSDEV(DS1,i,DS2,k,bestever.x(2),bestever.x(3));
usdkurs = ones(length(EURUSD_pre_oos.time),1);
[oosTime, oosAction] = buildActionMatrix(EURUSD_t1_oos,EURUSD_t2_oos,EURUSD_t2_oos,sys_par,fBuyEntry,fBuyExit,fSellEntry,fSellExit);
oosTradingTable = buildTradingTable(EURUSD_pre_oos, equityInit, usdkurs,comission,oosTime,oosAction*100000);
oosDailyTT = buildDailyTradingTable(oosTradingTable, equityInit);
