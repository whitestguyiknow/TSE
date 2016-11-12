function [obj,tradingTable,dailyTT] = optimintradayRSIFixCl(x,DSpre,DS1,DS2,sys_par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%exit rules: Fix stop loss/take profit

%buy rules: RSI
%parameter vector x:
nRSI = round(x(1)); %window length for RSI)
tp = x(2);          %take profit, tp >= 0)
sl = x(3);          %stop loss, sl >= 0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% artificial exchange rate
usdkurs = ones(length(DSpre.time),1);

% count trading days
nDays = countDays(DS1.time(1,:), DS1.time(end,:));

%% SECTION TO INSERT INDICATORS
% function handles to indicators

fBuyEntry =     @(DS1,i,DS2,k) entryBuyRSInew(DS1,i,nRSI);  %entry long
fSellEntry =    @(DS1,i,DS2,k) entrySellRSInew(DS1,i,nRSI);	%entry short
fBuyExit =      @(DS1,i,DS2,k) exitBuyFixTpSl(DS1,i,tp,sl);  	%exit long
fSellExit =     @(DS1,i,DS2,k) exitSellFixTpSl(DS1,i,tp,sl);  %exit short

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

