function [tradingTable] = buildTradingTable(DSpre,usdKurs,comission,tradeTime,position)
% comission [2 * comission per 100'000]

disp('building trading table..');
tic;

% exctract values
time = DSpre.time;
bid  = DSpre.bid;
ask  = DSpre.ask;

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

bruttoPnL = exitPrice.*entryPosition+entryPrice.*exitPosition; %Bruttorendite = (exitPrice-entryprice)/EntryPrice
bruttoPnLUSD = bruttoPnL.*usdKurs(tradeIdx(2:2:end));
<<<<<<< HEAD
comissionUSD = 2*abs(position(2:2:end)).*comission;
nettoPnLUSD = bruttoPnLUSD - comissionUSD;
nettoPnLPerComm = nettoPnLUSD./comissionUSD;
equity = cumsum(nettoPnLUSD)+100000; %%TODO: flexible position
=======
comissionUSD = 2*abs(position(2:2:end)).*comission; %Commision muss relativ gerechnet werden 0.00004 pro Seite
nettoPnLUSD = bruttoPnLUSD - comissionUSD; % netto return
nettoPnLPerComm = nettoPnLUSD./comissionUSD; %return per commision
equity = cumsum(nettoPnLUSD); %
%need an intraday return like: r(i)= (equity(i)-equity(i-1))/equity(i-1)
%Please insert
>>>>>>> e45eaefb665a39081c0b164f3c51cea0524b69bb

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
    'NettoPnLPerCommission','Duration','LowPrice','HighPrice','Equity'};

tradingTable = table(entryTimeVec,entryPrice,position(1:2:end-1),exitTimeVec,exitPrice,...
    bruttoPnL,usdrate(2:2:end),bruttoPnLUSD,comissionUSD,nettoPnLUSD,nettoPnLPerComm,...
    duration,lowPrice,highPrice,equity,'VariableNames',cnames);

disp('DONE!');
toc;
end


