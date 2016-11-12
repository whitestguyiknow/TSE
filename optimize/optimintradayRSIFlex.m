function [obj,tradingTable,dailyTT] = optimintradayRSIFlex(x,DSpre,DS1,DS2,sys_par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%exit rules: Flexible stop loss/take profit
%buy rules: RSI

%parameter vector x:
nRSI = round(x(1)); %window length for RSI
k1 = x(2);          %weighting factor for bollinger band, take profit
k2 = x(3);          %weighting factor for bollinger band, stop loss
nBB = round(x(4));         %window size for calculation of bollinger bands
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% artificial exchange rate
usdkurs = ones(length(DSpre.time),1);

%% SECTION TO INSERT INDICATORS
% function handles to indicators

fBuyEntry =     @(DS1,i,DS2,k) entryBuyRSInew(DS1,i,nRSI);  %entry long
fSellEntry =    @(DS1,i,DS2,k) entrySellRSInew(DS1,i,nRSI);	%entry short
fBuyExit =      @(DS1,i,DS2,k) exitBuyFlexTpSl(DS1,i,k1,k2,nBB);  	%exit long
fSellExit =     @(DS1,i,DS2,k) exitSellFlexTpSl(DS1,i,k1,k2,nBB);  %exit short

%% Evaluation
% initialize global indicator struct
setIndicatorStruct();

% action matrix and time
[Time, Action] = buildActionMatrix(DS1,DS2,fBuyEntry,fBuyExit,fSellEntry,fSellExit, sys_par);

% generate trades
tradingTable = buildTradingTable(DSpre,Time,Action*100000,usdkurs,sys_par);
dailyTT = buildDailyTradingTable(tradingTable, sys_par);
if sys_par.daily_optim 
    % daily optimization
    obj = -feval(sys_par.obj_func,dailyTT,nDays,sys_par);
else 
    % intraday optimization
    obj = -feval(sys_par.obj_func_intra,tradingTable,nDays,sys_par);
end
end

