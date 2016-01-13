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
EURUSD_t1 = tcompressMat(EURUSD_pre,1,'bid');
EURUSD_t2 = tcompressMat(EURUSD_pre,60,'bid');

% append indicator values


% artificial exchange rate
usdkurs = ones(length(EURUSD_pre.time),1);
comission = 0.5*8/100000;

% function handles to indicators
fBuyEntry = @(DS,i,DScompr1,k,DScompr2,l) entryBuyExample(DS,i,DScompr1,k,1);
fSellEntry = @(DS,i,DScompr1,k,DScompr2,l) entrySellExample(DS,i,DScompr1,k,1);
fBuyExit = @(DS,i,DScompr1,k,DScompr2,l) exitBuyExample(DS,i,DScompr1,k);
fSellExit = @(DS,i,DScompr1,k,DScompr2,l) exitSellExample(DS,i,DScompr1,k);

% initialize global indicator struct
setIndicatorStruct();

% action matrix and time
[Time, Action] = buildActionMatrix(EURUSD_t1,EURUSD_t2,EURUSD_t2,100,fBuyEntry,fBuyExit,fSellEntry,fSellExit);

% generate trades
tradingTable = buildTradingTable(EURUSD_pre.time,EURUSD_pre.bid,EURUSD_pre.ask,...
    usdkurs,comission,Time,Action*100000);

    


