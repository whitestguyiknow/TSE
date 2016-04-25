function [obj,tradingTable,dailyTT] = optimintradayMAFixCl(x,DSpre,DS1,DS2,sys_par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%exit rules: Fix stop loss/take profit
%buy rules: exponential moving average crossing system

%parameter vector x:
xEMA = round(x(1)); %number of samples shorter EMA, x <= tInit, INTEGER
yEMA = round(x(2)); %number of samples longer EMA, y+x <= tInit, INTEGER)
tp = x(3);          %take profit, tp >= 0
sl = x(4);          %stop loss, sl >= 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% artificial exchange rate
usdkurs = ones(length(DSpre.time),1);

% count trading days
nDays = countDays(DS1.time(1,:), DS1.time(end,:));


%% SECTION TO INSERT INDICATORS
% function handles to indicators

fBuyEntry =     @(DS1,i,DS2,k) entryBuyEMAXing(DS1,i,xEMA,yEMA);  % entry long position
fSellEntry =    @(DS1,i,DS2,k) entrySellEMAXing(DS1,i,xEMA,yEMA);	% entry short position
fBuyExit =      @(DS1,i,DS2,k) exitBuyFixTpSl(DS1,i,tp,sl);  	% exit short position, buy 
fSellExit =     @(DS1,i,DS2,k) exitSellFixTpSl(DS1,i,tp,sl);  % exit long posiition, sell

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

