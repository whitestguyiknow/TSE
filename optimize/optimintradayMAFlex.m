function [obj,tradingTable,dailyTT] = optimintradayMAFlex(x,DSpre,DS1,DS2,sys_par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%exit rules: Flexible stop loss/take profit
%buy rules: exponential moving average crossing system

%parameter vector x:
k1 = x(1);              %weighting factor for bollinger band, take profit
k2 = x(2);              %weighting factor for bollinger band, stop loss
nBB = round(x(3));      %window size for calculation of bollinger bands
xEMA = round(x(4));     %number of samples shorter EMA, x <= tInit, INTEGER
yEMA = round(x(5));     %number of samples longer EMA, y+x <= tInit, INTEGER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% artificial exchange rate
usdkurs = ones(length(DSpre.time),1);

%% SECTION TO INSERT INDICATORS
% function handles to indicators

fBuyEntry =     @(DS1,i,DS2,k) entryBuyEMAXing(DS1,i,xEMA,yEMA);  %entry long
fSellEntry =    @(DS1,i,DS2,k) entrySellEMAXing(DS1,i,xEMA,yEMA);	%entry short
fBuyExit =      @(DS1,i,DS2,k) exitBuyFlexTpSl(DS1,i,k1,k2,nBB);  	%exit long
fSellExit =     @(DS1,i,DS2,k) exitSellFlexTpSl(DS1,i,k1,k2,nBB);  %exit short

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

%% plot
% lineVec = [min(DS1.ask_open);max(DS1.ask_open)];
% timeVecTmp = datenum(DS1.time);
% ask_open_filtx = tsmovavg(DS1.ask_open,'e',x(3),1);
% ask_open_filty = tsmovavg(DS1.ask_open,'e',x(4),1);
% 
% ask_close_filtx = tsmovavg(DS1.ask_close,'e',x(3),1);
% ask_close_filty = tsmovavg(DS1.ask_close,'e',x(4),1);
% 
% bid_open_filtx = tsmovavg(DS1.bid_open,'e',x(3),1);
% bid_open_filty = tsmovavg(DS1.bid_open,'e',x(4),1);
% 
% bid_close_filtx = tsmovavg(DS1.bid_close,'e',x(3),1);
% bid_close_filty = tsmovavg(DS1.bid_close,'e',x(4),1);
% 
% figure(69)
% sub1 = subplot(4,1,1);
% plot(timeVecTmp,DS1.ask_open)
% hold on
% plot(timeVecTmp,ask_open_filtx)
% plot(timeVecTmp,ask_open_filty)
% plot(repmat(Time(Action>0)',2,1),repmat(lineVec,1,length(Time(Action>0))),'g')
% plot(repmat(Time(Action<0)',2,1),repmat(lineVec,1,length(Time(Action<0))),'r')
% plot(timeVecTmp(sys_par.tInit)*ones(2,1),lineVec,'k--')
% hold off
% title('ask open')

% sub2 = subplot(4,1,2);
% plot(timeVecTmp,DS1.ask_close)
% hold on
% plot(timeVecTmp,ask_close_filtx)
% plot(timeVecTmp,ask_close_filty)
% hold off
% title('ask close')
% 
% sub3 = subplot(4,1,3);
% plot(timeVecTmp,DS1.bid_open)
% hold on
% plot(timeVecTmp,bid_open_filtx)
% plot(timeVecTmp,bid_open_filty)
% hold off
% title('bid open')
% 
% sub4 = subplot(4,1,4);
% plot(timeVecTmp,DS1.bid_close)
% hold on
% plot(timeVecTmp,bid_close_filtx)
% plot(timeVecTmp,bid_close_filty)
% hold off
% title('bid close')
% 
% linkaxes([sub1,sub2,sub3,sub4],'x')

%%
end

