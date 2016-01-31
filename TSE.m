%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            TRADER SYSTEM ENGINE
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
%                   data in ./dat/
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% setup
setup();

% tasks
opt = true;

tInit = 100;
deltaRSI = 0.058268;

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
    fBuyRSI = @(DS,i,t) BuyRSI(DS,i,t);
    fSellRSI = @(DS,i,t) SellRSI(DS,i,t);
    fSdev = @(DS,i,t) sdev(DS,i,t);
    
    % append indicator values
    EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'buyRSI_14',fBuyRSI,14);
    EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'buyRSI_30',fBuyRSI,30);
    EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'sellRSI_14',fSellRSI,14);
    EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'sellRSI_30',fSellRSI,30);
    EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'sdev',fSdev,50);
    
    EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'buyRSI_14',fBuyRSI,14);
    EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'buyRSI_30',fBuyRSI,30);
    EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'sellRSI_14',fSellRSI,14);
    EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'sellRSI_30',fSellRSI,30);
    EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'sdev',fSdev,50);
    
    % save dataset
    save './dat/EURUSD.mat' EURUSD_t1 EURUSD_t2
end

% artificial exchange rate
usdkurs = ones(length(EURUSD_pre.time),1);
comission = 0.5*8/100000;

% function handles to indicators
fBuyEntry = @(DS1,i,DS2,k,DS3,l) entryBuyRSI(DS1,i,DS2,k,deltaRSI);
fSellEntry = @(DS1,i,DS2,k,DS3,l) entrySellRSI(DS1,i,DS2,k,deltaRSI);
fBuyExit = @(DS1,i,DS2,k,DS3,l) exitBuyTrailingSDEV(DS1,i,DS2,k);
fSellExit = @(DS1,i,DS2,k,DS3,l) exitSellTrailingSDEV(DS1,i,DS2,k);

% initialize global indicator struct
setIndicatorStruct();

% action matrix and time
[Time, Action] = buildActionMatrix(EURUSD_t1,EURUSD_t2,EURUSD_t2,tInit,fBuyEntry,fBuyExit,fSellEntry,fSellExit);

% generate trades
tradingTable = buildTradingTable(EURUSD_pre, usdkurs,comission,Time,Action*100000);

% summary
dailyTT = buildDailyTradingTable(tradingTable);

% sharpe-ratio
sharpe = sharpeRatio(dailyTT);


    
    
