function [obj] = optimintradayMAFix(x,DSpre,DS1,DS2,sys_par)
% for testing:
% clear
% close all
% clc
% load('EURNOK6M60120.mat')
% 
% DSpre = EURNOK_pre;
% DS1 = EURNOK_t1;
% DS2 = EURNOK_t2;
% x = [0.01;0.01;4;20];
% sys_par = getSysPar();
% 
% % function handles to precomputed, global indicators
% fSdev = @(DS,i,t) sdev(DS,i,t);% Standarddeviation of underlying of last t datapoints
% 
% % append indicator values
% DS1 = appendIndicator(DS1,sys_par,'sdev',fSdev,50);
% DS2 = appendIndicator(DS2,sys_par,'sdev',fSdev,50);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%exit rules: Fix stop loss/take profit
%buy rules: exponential moving average crossing system
%parameter vector x:
    %x(1) = tp  (take profit, tp >= 0)
    %x(2) = sl  (stop loss, sl >= 0)
    %x(3) = x   (number of samples shorter EMA, x <= tInit, INTEGER)
    %x(4) = y   (number of samples longer EMA, y <= tInit, INTEGER)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% artificial exchange rate
usdkurs = ones(length(DSpre.time),1);

% make shure x(3), x(4) are integers
x(3) = round(x(3));
x(4) = round(x(4));

%% SECTION TO INSERT INDICATORS
% function handles to indicators

fBuyEntry =     @(DS1,i,DS2,k) entryBuyEMAXing(DS1,i,x(3),x(4));  %entry long
fSellEntry =    @(DS1,i,DS2,k) entrySellEMAXing(DS1,i,x(3),x(4));	%entry short
fBuyExit =      @(DS1,i,DS2,k) exitBuyFixTpSl(DS1,i,x(1),x(2));  	%exit long
fSellExit =     @(DS1,i,DS2,k) exitSellFixTpSl(DS1,i,x(1),x(2));  %exit short

%% Evaluation
% initialize global indicator struct
setIndicatorStruct();

% action matrix and time
[Time, Action] = buildActionMatrix(DS1,DS2,fBuyEntry,fBuyExit,fSellEntry,fSellExit, sys_par);

%  intraday Trades generate trades
tradingtable = buildTradingTable(DSpre,Time,Action*100000,usdkurs,sys_par);


% objective function, declared in sys_par
obj = -feval(sys_par.obj_func_intra,tradingtable);

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

