function [tradingTable] = buildTraidingTable(time,bid,ask,usdKurs,comission,tradeTime,position)
time = datenum(time);
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

entryTime   = zeros(m,1);
entryPrice  = zeros(m,1);
entryPosition    = zeros(m,1);
exitPosition    = zeros(m,1);
exitTime    = zeros(m,1);
exitPrice   = zeros(m,1);
lowPrice    = zeros(m,1);
highPrice   = zeros(m,1);
usdrate     = zeros(m,1);

tradeIdx = zeros(1,m);

idx=1;
for i = 1:2:l
        
    t = tradeTime(i);
    j = find(time>=t,1,'first');
    %TODO:
    %Improve time finder
    %store actual position
    tradeIdx(i) = j;
    entryTime(idx) = time(j);
    entryPosition(idx) = position(i);
    if(position(i)>0)
        entryPrice(idx)=ask(j);
    else
        entryPrice(idx)=bid(j);
    end
    usdrate(i) = usdKurs(j);
    
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
    usdrate(i+1) = usdKurs(j);
    idx = idx+1;
end

bruttoPnL = exitPrice.*entryPosition+entryPrice.*exitPosition;
bruttoPnLUSD = bruttoPnL.*usdKurs(tradeIdx(2:2:end));
comissionUSD = 2*abs(position(2:2:end)).*comission;
nettoPnLUSD = bruttoPnLUSD - comissionUSD;
entryTimeVec = datevec(entryTime);
exitTimeVec = datevec(exitTime);
duration = etime(exitTimeVec,entryTimeVec);
nettoPnLPerComm = nettoPnLUSD./comissionUSD;
equity = cumsum(nettoPnLUSD);

idx = 1;
for i = 1:m
    I = tradeIdx(idx):tradeIdx(idx+1);
    lowPrice(i) = min(bid(I));
    highPrice(i) = max(ask(I));
    idx = idx+2;
end

cnames = {'EntryTime','EntryPrice','Position','ExitTime','ExitPrice',...
    'BruttoPnL','USDKurs','BruttoPnLUSD','Commssion','NettoPnLUSD',...
    'NettoPnLPerCommission','Duration','LowPrice','HighPrice','Equity'};

tradingTable = table(entryTimeVec,entryPrice,position(1:2:end-1),exitTimeVec,exitPrice,...
    bruttoPnL,usdrate(2:2:end),bruttoPnLUSD,comissionUSD,nettoPnLUSD,nettoPnLPerComm,...
    duration,lowPrice,highPrice,equity,'VariableNames',cnames);

end


