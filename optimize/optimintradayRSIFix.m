function [obj,tradingTable,dailyTT] = optimintradayRSIFix(x,DSpre,DS1,DS2,sys_par)
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

%  intraday Trades generate trades
tradingTable = buildTradingTable(DSpre,Time,Action*100000,usdkurs,sys_par);

% summary
dailyTT = buildDailyTradingTable(tradingTable, sys_par);

% objective function, declared in sys_par
obj = -feval(sys_par.obj_func,dailyTT,sys_par);

end

