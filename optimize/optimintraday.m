function [obj] = optimintraday(x,DSpre,DS1,DS2,sys_par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function: exanple function feeding into DEoptim           

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% artificial exchange rate
usdkurs = ones(length(DSpre.time),1);

%% SECTION TO INSERT INDICATORS
% function handles to indicators
lookback = 10;
fBuyEntry = @(DS1,i,DS2,k) entryBuyStoch(DS1,i,DS2,k,lookback,x(1));
fSellEntry = @(DS1,i,DS2,k) entrySellStoch(DS1,i,DS2,k,lookback,x(1));
fBuyExit = @(DS1,i,DS2,k) exitBuyTrailingSDEV(DS1,i,DS2,k,x(2),x(2));
fSellExit = @(DS1,i,DS2,k) exitSellTrailingSDEV(DS1,i,DS2,k,x(3),x(3));

%% Evaluation
% initialize global indicator struct
setIndicatorStruct();

% action matrix and time
[Time, Action] = buildActionMatrix(DS1,DS2,fBuyEntry,fBuyExit,fSellEntry,fSellExit, sys_par);

%  intraday Trades generate trades
tradingtable = buildTradingTable(DSpre,Time,Action*100000,usdkurs,sys_par);


% objective function, declared in sys_par
obj = -feval(sys_par.obj_func_intra,tradingtable);

end

