function [tradingTable] = buildTraidingTable(time,bid,ask,usdKurs,comission,tradeTime,position)
l = length(position);
N = length(time);
m = l/2;

assert(sum(position)==0,'position must be even out');
assert(length(tradeTime)==l);
assert(length(bid)==N);
assert(length(ask)==N);
assert(length(usdKurs)==N);
assert(mod(l,2)==0);

entryTime   = zeros(m,1);
entryPrice  = zeros(m,1);
%position    = zeros(m,1);
exitTime    = zeros(m,1);
exitPrice   = zeros(m,1);
lowPrice    = zeros(m,1);
highPrice   = zeros(m,1);

tradeIdx = zeros(1,l);

for i = 1:2:l
    t = tradeTime(i);
    j = find(time>=t,1,'first');
    tradeIdx(i) = j;
    entryTime(i) = time(j);
    if(position(i)>0)
        entryPrice(i)=ask(j);
    else
        entryPrice(i)=bid(j);
    end
    
    t = tradeTime(i+1);
    j = find(time>=t,1,'first');
    tradeIdx(i+1) = j;
    exitTime(i+1) = time(j);
    if(position(i+1)>0)
        exitPrice(i+1)=ask(j);
    else
        exitPrice(i+1)=bid(j);
    end
end

bruttoPnL = (exitPrice-entryPrice).*position;
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


