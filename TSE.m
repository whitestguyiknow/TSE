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
EURUSDcompr_DS1 = tcompressMat(EURUSD_DS,1,'bid');
EURUSDcompr_DS2 = tcompressMat(EURUSD_DS,2,'bid');

usdkurs = ones(length(EURUSD_DS.time),1);
comission = 100;

fBuyEntry = @(DS,i,DScompr1,k,DScompr2,l) entryBuyExample(DS,DScompr1,k,1);
fSellEntry = @(DS,i,DScompr1,k,DScompr2,l) entrySellExample(DS,DScompr1,k,1);
fBuyExit = @(DS,i,DScompr1,k,DScompr2,l,buyPrice) exitBuyExample(DS,DScompr1,k,buyPrice);
fSellExit = @(DS,i,DScompr1,k,DScompr2,l,sellPrice) exitSellExample(DS,DScompr1,k,sellPrice);

[Time, Action] = buildActionMatrix(EURUSD_DS,EURUSDcompr_DS1,EURUSDcompr_DS2,100,fBuyEntry,fBuyExit,fSellEntry,fSellExit);

%[exampleTradingTime, examplePosition] = getExampleTrades(10,EURUSDcompr_DS.time);
%tradingTable = buildTraidingTable(EURUSD_DS.time,EURUSD_DS.bid,EURUSD_DS.ask,...
%    usdkurs,comission,exampleTradingTime,examplePosition);

tradingTable = buildTraidingTable(EURUSD_DS.time,EURUSD_DS.bid,EURUSD_DS.ask,...
    usdkurs,comission,Time,Action);

    


