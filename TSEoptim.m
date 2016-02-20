%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            First Optimization
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
dbstop if error

tInit = 100;

% partitioning variable
insamplePCT = 0.7;

% try load
try
    clear EURUSD
    EURUSD = load('./dat/EURUSD.mat');
    EURUSD_pre = EURUSD.EURUSD_pre;
    EURUSD_t1 = EURUSD.EURUSD_t1;
    EURUSD_t2 = EURUSD.EURUSD_t2;
catch   
    % load & process data
    EURUSD_pre = loadDataCsv('EURUSD_tick.csv');
    EURUSD_t1 = compress(EURUSD_pre,15,'bid','ask');
    EURUSD_t2 = compress(EURUSD_pre,60,'bid','ask');
    
    % function handles to precomputed indicators
%     fBuyRSI = @(DS,i,t) BuyRSI(DS,i,t);
%     fSellRSI = @(DS,i,t) SellRSI(DS,i,t);
%     fSdev = @(DS,i,t) sdev(DS,i,t);
    
    % append indicator values
    %EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'buyRSI_14',fBuyRSI,14);
    %EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'buyRSI_30',fBuyRSI,30);
    %EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'sellRSI_14',fSellRSI,14);
    %EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'sellRSI_30',fSellRSI,30);
    EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'sdev',fSdev,50);
    
    %EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'buyRSI_14',fBuyRSI,14);
    %EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'buyRSI_30',fBuyRSI,30);
    %EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'sellRSI_14',fSellRSI,14);
    %EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'sellRSI_30',fSellRSI,30);
    EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'sdev',fSdev,50);
    
    % save dataset
    save './dat/EURUSD.mat' EURUSD_pre EURUSD_t1 EURUSD_t2 
end

% pick isamples
% & osamples

% optim parameter
nPopoulation = 30;
maxIter = 2;
CR = 0.7;
F = 1.5;
N_cpu = 2;
seed = 8392;
optimStruct = generateOptimStruct(nPopoulation,maxIter,CR,F,seed,N_cpu);

% partitioning
% insamle
lp = length(EURUSD_pre); l1 = length(EURUSD_t1); l2 = length(EURUSD_t2);
EURUSD_pre_is = EURUSD_pre(1:ceil(lp*insamplePCT),:);
EURUSD_t1_is = EURUSD_t1(1:ceil(l1*insamplePCT),:);
EURUSD_t2_is = EURUSD_t2(1:ceil(l2*insamplePCT),:);
% osample
EURUSD_pre_oos = EURUSD_pre(floor(lp*insamplePCT):end,:);
EURUSD_t1_oos = EURUSD_t1(floor(l1*insamplePCT):end,:);
EURUSD_t2_oos = EURUSD_t2(floor(l2*insamplePCT):end,:);

% optimization
fileName = './dat/Stoch_optim.csv';
% objective function -sharpe, minimize neg sharpe -> maximize sharp
%f = @(x) -optim(EURUSD_pre_is,EURUSD_t1_is,EURUSD_t2_is,x(1),x(2),x(3));
%[obj,par] = DEoptim(f,optimStruct,[3,40],[0.1,15],[0.1,15],fileName);

% load from previous run
loaded_Par = dlmread(fileName, ',', 3, 0);
best_par = loaded_Par(end,1:end-1);
best_fObj = loaded_Par(end,end);

% out of sample run
LB = 10;
fBuyEntry = @(DS1,i,DS2,k,DS3,l) entryBuyStoch(DS1,i,DS2,k,LB,best_par(1));
fSellEntry = @(DS1,i,DS2,k,DS3,l) entrySellStoch(DS1,i,DS2,k,LB,best_par(1));
fBuyExit = @(DS1,i,DS2,k) exitBuyTrailingSDEV(DS1,i,DS2,k,best_par(2),best_par(3));
fSellExit = @(DS1,i,DS2,k) exitSellTrailingSDEV(DS1,i,DS2,k,best_par(2),best_par(3));
usdkurs = ones(length(EURUSD_pre_oos.time),1);
comission = 0.5*8/100000;
equityInit = 100000;
[oosTime, oosAction] = buildActionMatrix(EURUSD_t1_oos,EURUSD_t2_oos,EURUSD_t2_oos,tInit,fBuyEntry,fBuyExit,fSellEntry,fSellExit);
oosTradingTable = buildTradingTable(EURUSD_pre_oos, equityInit, usdkurs,comission,oosTime,oosAction*100000);
oosDailyTT = buildDailyTradingTable(oosTradingTable, equityInit);
