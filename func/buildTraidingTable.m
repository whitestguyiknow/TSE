function [tradingTable] = buildTraidingTable(time,bid,ask,usdKurs,comission,tradeTime,position)
l = length(position);
N = length(time);
m = l/2;

assert(mod(l,2)==0);
assert(sum(position)==0,'position must be even out');
assert(length(tradeTime)==l);
assert(length(bid)==N);
assert(length(ask)==N);
assert(length(usdKurs)==N);
assert(mod(l,2)==0);

entryTime   = zeros(l,1);
entryPrice  = zeros(l,1);
entryPosition    = zeros(l,1);
exitPosition    = zeros(l,1);
exitTime    = zeros(l,1);
exitPrice   = zeros(l,1);
lowPrice    = zeros(l,1);
highPrice   = zeros(l,1);

tradeIdx = zeros(1,l);

idx=1;
for i = 1:2:l
    
    t = tradeTime(i);
    j = find(time>=t,1,'first');
    tradeIdx(i) = j;
    entryTime(idx) = time(j);
    entryPosition(idx) = position(i);
    if(position(i)>0)
        entryPrice(idx)=ask(j);
    else
        entryPrice(idx)=bid(j);
    end
    
    t = tradeTime(i+1);
    j = find(time>=t,1,'first');
    tradeIdx(i+1) = j;
    exitTime(idx) = time(j);
    exitPosition(idx) = position(i+1);
    if(position(i+1)>0)
        exitPrice(idx)=ask(j);
    else
        exitPrice(idx)=bid(j);
    end
    idx = idx+1;
end

bruttoPnL = exitPrice.*entryPosition-entryPrice.*exitPosition;
bruttoPnLUSD = bruttoPnL.*usdKurs(tradeIdx);
commissionUSD = abs(position).*comission;
nettoPnLUSD = bruttoPnLUSD - comissionUSD;
duration = exitTime - entryTime;
nettoPnLPerComm = nettoPnLUSD./commissionUSD;
equity = cumsum(nettoPnLUSD);

for i = 1:2:l/2
    I = tradeIdx(i):tradeIdx(i+1);
    lowPrice(i) = min(bid(I));
    highPrice(i) = max(ask(I));
end

cnames = {'EntryTime','EntryPrice','Position','ExitTime','ExitPrice',...
    'BruttoPnL','USDKurs','BruttoPnLUSD','Commssion','NettoPnLUSD',...
    'NettoPnLPerCommission','Duration','LowPrice','HighPrice','Equity'};

tradingTable = table(entryTime,entryPrice,position,exitTime,exitPrice,...
    bruttoPnL,usdKurs,bruttoPnLUSD,commissionUSD,nettoPnLUSD,nettoPnLPerComm,...
    duration,lowPrice,highPrice,equity,'VariableNames',cnames);

end


