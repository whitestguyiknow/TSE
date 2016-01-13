 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            TRADER SYSTEM ENGINE
%                    
% Authors:          Daniel Waelchli, Mike Schwitalla
% Date:             June 2015
% Version:          1.01
%
% Description:      main engine, 
%                   function collection in ./func/
%                   indicator functions in ./indicators/
%                   data in ./dat/
%                   
%                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% setup
setup();

% generate data
EURUSD_raw = loadData('EURUSD_tick.csv');
EURUSD_pre = preprocessTable(EURUSD_raw);
EURUSD_t1 = tcompressMat(EURUSD_pre,15,'bid');
EURUSD_t2 = tcompressMat(EURUSD_pre,60,'bid');

% append indicator values


% artificial exchange rate
usdkurs = ones(length(EURUSD_pre.time),1);
comission = 0.5*8/100000;

deltaRSI = 0.15;
% function handles to indicators
fBuyEntry = @(DS1,i,DS2,k,DS3,l) entryBuyRSI(DS1,i,DS2,k,14,30,deltaRSI);
fSellEntry = @(DS1,i,DS2,k,DS3,l) entrySellRSI(DS1,i,DS2,k,14,30,deltaRSI);
fBuyExit = @(DS1,i,DS2,k,DS3,l) exitBuyTrailingSDEV(DS1,i,DS2,k,50);
fSellExit = @(DS1,i,DS2,k,DS3,l) exitSellTrailingSDEV(DS1,i,DS2,k,50);

% initialize global indicator struct
setIndicatorStruct();

% action matrix and time
[Time, Action] = buildActionMatrix(EURUSD_t1,EURUSD_t2,EURUSD_t2,100,fBuyEntry,fBuyExit,fSellEntry,fSellExit);

% generate trades
tradingTable = buildTradingTable(EURUSD_pre.time,EURUSD_pre.bid,EURUSD_pre.ask,...
    usdkurs,comission,Time,Action*100000);


    


