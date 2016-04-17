function [obj,tradingTable,dailyTT] = optim(x,DSpre,DS1,DS2,sys_par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function: exanple function feeding into DEoptim           
% created by Daniel, December 2015
%
% Last update: 2016 Jan 31, by Daniel
%   2016-03-28: (Daniel)
%       1. all optimization params in x
%   2016-01-31: (Daniel)
%       1. restructuring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% artificial exchange rate
usdkurs = ones(length(DSpre.time),1);

%% SECTION TO INSERT INDICATORS
% function handles to indicators
% x(1) additional (long) looback time in stoch. osc.
% x(2) (short) lookback time in stoch. osc.
% x(3) lower exit STDdev factor
% x(4) upper exit STDdev factor
fBuyEntry = @(DS1,i,DS2,k) entryBuyStoch(DS1,i,DS2,k,x(1),x(2));
fSellEntry = @(DS1,i,DS2,k) entrySellStoch(DS1,i,DS2,k,x(1),x(2));
fBuyExit = @(DS1,i,DS2,k) exitBuyTrailingSDEV(DS1,i,DS2,k,x(3),x(3));
fSellExit = @(DS1,i,DS2,k) exitSellTrailingSDEV(DS1,i,DS2,k,x(4),x(4));

% make shure x(3), x(4) are integers
x(1) = round(x(1));
x(2) = round(x(2));

%% SECTION TO INSERT INDICATORS
% function handles to indicators

fBuyEntry =     @(DS1,i,DS2,k) entryBuyEMAXing(DS1,i,x(1),x(2));  %entry long
fSellEntry =    @(DS1,i,DS2,k) entrySellEMAXing(DS1,i,x(1),x(2));	%entry short
fBuyExit =      @(DS1,i,DS2,k) exitBuyFixTpSl(DS1,i,x(3),x(4));  	%exit long
fSellExit =     @(DS1,i,DS2,k) exitSellFixTpSl(DS1,i,x(3),x(4));  %exit short

%% Evaluation
% initialize global indicator struct
setIndicatorStruct();

% action matrix and time
[Time, Action] = buildActionMatrix(DS1,DS2,fBuyEntry,fBuyExit,fSellEntry,fSellExit, sys_par);

% generate trades
tradingTable = buildTradingTable(DSpre,Time,Action*100000,usdkurs,sys_par);

if sys_par.daily_optim 
    % daily optimization
    dailyTT = buildDailyTradingTable(tradingTable, sys_par);
    obj = -feval(sys_par.obj_func,dailyTT,sys_par);
else 
    % intraday optimization
    obj = -feval(sys_par.obj_func_intra,tradingTable,sys_par);
end

end

