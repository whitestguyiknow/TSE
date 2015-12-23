 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            TRADER SYSTEM ENGINE
%                    
% Authors:          Daniel Waelchli, Mike Schwitalla
% Date:             June 2015
% Version:          1.01
%
% Description:      main engine, function collection in ./func/
%                   data in ./dat/
%                   
%                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear all;
setup();


EURUSD = loadData('EURUSD_SHORTER.csv');
EURUSD_DS = preprocessTable(EURUSD);
EURUSDcompr_DS = tcompressMat(EURUSD_DS,1,'bid');

usdkurs = ones(length(EURUSD_DS.time),1);
comission = 100;

fBuyEntry = @(DScomp,i) entryBuyExample(DScomp,i,1);
fSellEntry = @(DScomp,i) entrySellExample(DScomp,i,1);
fBuyExit = @(DS,DScomp,i,buyPrice) exitBuyExample(DS,DScomp,i,buyPrice);
fSellExit = @(DS,DScomp,i,sellPrice) exitSellExample(DS,DScomp,i,sellPrice);

[Time, Action] = buildActionMatrix(EURUSD_DS,EURUSDcompr_DS,4,fBuyEntry,fBuyExit,fSellEntry,fSellExit);

%[exampleTradingTime, examplePosition] = getExampleTrades(10,EURUSDcompr_DS.time);
%tradingTable = buildTraidingTable(EURUSD_DS.time,EURUSD_DS.bid,EURUSD_DS.ask,...
%    usdkurs,comission,exampleTradingTime,examplePosition);

tradingTable = buildTraidingTable(EURUSD_DS.time,EURUSD_DS.bid,EURUSD_DS.ask,...
    usdkurs,comission,Time,Action);

    


