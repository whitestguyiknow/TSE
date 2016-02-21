function [sharpe] = optim(DSpre,DS1,DS2,sys_par,x,Clow,Chigh)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function: exanple function feeding into DEoptim           
% created by Daniel, December 2015
%
% Last update: 2016 Jan 31, by Daniel
%   2016-01-31: (Daniel)
%       1. restructuring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% warm up time
tInit = sys_par.tInit;
equityInit = sys_par.equityInit;

% artificial exchange rate
usdkurs = ones(length(DSpre.time),1);
comission = sys_par.comission;

%% SECTION TO INTERCHANGE INDICATORS
% function handles to indicators
lookback = 10;
fBuyEntry = @(DS1,i,DS2,k,DS3,l) entryBuyStoch(DS1,i,DS2,k,lookback,x);
fSellEntry = @(DS1,i,DS2,k,DS3,l) entrySellStoch(DS1,i,DS2,k,lookback,x);
fBuyExit = @(DS1,i,DS2,k) exitBuyTrailingSDEV(DS1,i,DS2,k,Clow,Chigh);
fSellExit = @(DS1,i,DS2,k) exitSellTrailingSDEV(DS1,i,DS2,k,Clow,Chigh);
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

