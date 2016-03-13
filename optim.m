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

% artificial exchange rate
usdkurs = ones(length(DSpre.time),1);

%% SECTION TO INTERCHANGE INDICATORS
% function handles to indicators
lookback = 10;
fBuyEntry = @(DS1,i,DS2,k) entryBuyStoch(DS1,i,DS2,k,lookback,x);
fSellEntry = @(DS1,i,DS2,k) entrySellStoch(DS1,i,DS2,k,lookback,x);
fBuyExit = @(DS1,i,DS2,k) exitBuyTrailingSDEV(DS1,i,DS2,k,Clow,Chigh);
fSellExit = @(DS1,i,DS2,k) exitSellTrailingSDEV(DS1,i,DS2,k,Clow,Chigh);
%%

% initialize global indicator struct
setIndicatorStruct();

% action matrix and time
[Time, Action] = buildActionMatrix(DS1,DS2,fBuyEntry,fBuyExit,fSellEntry,fSellExit, sys_par);

% generate trades
tradingTable = buildTradingTable(DSpre,Time,Action*100000,usdkurs,sys_par);

% summary
dailyTT = buildDailyTradingTable(tradingTable, sys_par);

% sharpe-ratio
sharpe = sharpeRatio(dailyTT);
end

