function [sharpe] = optimold(DSpre,DS1,DS2,deltaRSI)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function: exanple function feeding into DEoptim           
% created by Daniel, December 2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% warm up time
tInit = 100;
equityInit = 100000;

% artificial exchange rate
usdkurs = ones(length(DSpre.time),1);
comission = 0.5*8/100000;

%% SECTION TO INTERCHANGE INDICATORS
% function handles to indicators
fBuyEntry = @(DS1,i,DS2,k,DS3,l) entryBuyRSI(DS1,i,DS2,k,deltaRSI);
fSellEntry = @(DS1,i,DS2,k,DS3,l) entrySellRSI(DS1,i,DS2,k,deltaRSI);
fBuyExit = @(DS1,i,DS2,k,DS3,l) exitBuyTrailingSDEV(DS1,i,DS2,k);
fSellExit = @(DS1,i,DS2,k,DS3,l) exitSellTrailingSDEV(DS1,i,DS2,k);
%%

% initialize global indicator struct
setIndicatorStruct();

% action matrix and time
[Time, Action] = buildActionMatrix(DS1,DS2,DS2,tInit,fBuyEntry,fBuyExit,fSellEntry,fSellExit);

% generate trades
tradingTable = buildTradingTable(DSpre, equityInit, usdkurs,comission,Time,Action*100000);

% summary
dailyTT = buildDailyTradingTable(tradingTable, equityInit);

% sharpe-ratio
sharpe = sharpeRatio(dailyTT);
end

