function [tradingTable] = buildTradingTable(DSpre,tradeTime,position,usdKurs,sys_par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function: summarize all trades
% created by Daniel, December 2015
%
% Last update: 2016 Jan 31, by Daniel
%   2016-01-31: (Daniel)
%       1. insert equity init for return calculation; restructuring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
if sys_par.echo
    disp('building trading table..');
    tic;
end
 
% exctract values
time = DSpre.time;
bid  = DSpre.bid;
ask  = DSpre.ask;
 
equityInit = sys_par.equityInit;
comission = sys_par.comission;
 
% convert time for calculations
time = datenum(time);
 
l = length(position);
N = length(time);
m = l/2;
 
% assertions
assert(mod(l,2)==0);
assert(sum(position)==0,'position must be even out');
assert(length(tradeTime)==l);
assert(length(bid)==N);
assert(length(ask)==N);
assert(length(usdKurs)==N);
assert(mod(l,2)==0);
 
if l<3
    tradingTable = [];
    return
end
    
% initialization
entryTime   = zeros(m,1);
entryTimeVec = zeros(m,6);
entryPrice  = zeros(m,1);
entryPosition    = zeros(m,1);
exitPosition    = zeros(m,1);
exitTime    = zeros(m,1);
exitTimeVec = zeros(m,6);
duration    = zeros(m,1);
exitPrice   = zeros(m,1);
lowPrice    = zeros(m,1);
highPrice   = zeros(m,1);
usdrate     = zeros(m,1);
 
tradeIdx = zeros(1,m);
 
idx=1; j=1;
for i = 1:2:l
    
    t = tradeTime(i);
    j = findPrevious(time,t,j);
    tradeIdx(i) = j;
    entryTime(idx) = time(j);
    entryPosition(idx) = position(i);
    if(position(i)>0)
        % buy
        entryPrice(idx)=ask(j);
    else
        % sell
        entryPrice(idx)=bid(j);
    end
    usdrate(i) = usdKurs(j);
    
    t = tradeTime(i+1);
    j = find(time>=t,1,'first');
    tradeIdx(i+1) = j;
    exitTime(idx) = time(j);
    entryTimeVec(idx,:) = datevec(entryTime(idx));
    exitTimeVec(idx,:) = datevec(exitTime(idx));
    duration(idx) = etime(exitTimeVec(idx,:),entryTimeVec(idx,:));
    exitPosition(idx) = position(i+1);
    if(position(i+1)>0)
        % buy - go flat
        exitPrice(idx)=ask(j);
    else
        % sell - go flat
        exitPrice(idx)=bid(j);
    end
    usdrate(i+1) = usdKurs(j);
    idx = idx+1;
end
 
bruttoReturns = entryPosition./abs(entryPosition) .* (exitPrice-entryPrice)./entryPrice;
nettoReturns = bruttoReturns - 2*sys_par.comission./abs(entryPosition);
 
 
comissionUSD = 2*abs(position(2:2:end)).*comission./100000;
nettoPnLUSD = abs(entryPosition).*nettoReturns;
nettoPnL = abs(entryPosition).*nettoReturns;

bruttoPnLUSD = nettoPnL+2*sys_par.comission;
bruttoPnL = nettoPnL+2*sys_par.comission;

nettoPnLPerComm = nettoPnLUSD./comissionUSD;
equity = cumsum(nettoPnLUSD)+equityInit; %%TODO: flexible position
 
 
% calculate low and high Prices during positioning
idx = 1;
for i = 1:m
    I = tradeIdx(idx):tradeIdx(idx+1);
    lowPrice(i) = min(bid(I));
    highPrice(i) = max(ask(I));
    idx = idx+2;
end
 
cnames = {'EntryTime','EntryPrice','Position','ExitTime','ExitPrice',...
    'BruttoPnL','USDKurs','BruttoPnLUSD','Commssion','NettoPnLUSD',...
    'NettoPnLPerCommission','Duration','LowPrice','HighPrice','Return','Equity'};
 
tradingTable = table(entryTimeVec,entryPrice,position(1:2:end-1),exitTimeVec,exitPrice,...
    bruttoPnL,usdrate(2:2:end),bruttoPnLUSD,comissionUSD,nettoPnLUSD,nettoPnLPerComm,...
    duration,lowPrice,highPrice,nettoReturns,equity,'VariableNames',cnames);
 
if sys_par.echo
    disp('DONE!');
    toc;
end
 
end
 
 

