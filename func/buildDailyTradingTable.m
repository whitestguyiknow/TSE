function [dailyTradingTable] = buildDailyTradingTable(tradingTable)
% summarize trades within each day
disp('building daily trading table..');
tic;

if(isempty(tradingTable) || height(tradingTable)<10) % 10 min trades for now..
    dailyTradingTable = [];
    return 
end

tradingIntervall = tradingTable.ExitTime(end,:) - tradingTable.EntryTime(1,:);
M = 365*tradingIntervall(1)+30*tradingIntervall(2)+tradingIntervall(3);

dates     = zeros(M,3);
cumTrades = zeros(M,1);
equity    = zeros(M,1);


idx=1;
day = tradingTable.EntryTime(1,3);
for i = 2:length(tradingTable.ExitTime)
    % check if exit times is at another day
    if(tradingTable.ExitTime(i,3)~=day) %TODO: maybe some trades are getting lost here, check
        % update new trading day
        dates(idx,:)   = tradingTable.ExitTime(i-1,1:3);
        equity(idx)    = tradingTable.Equity(i-1);
        cumTrades(idx) = i;
        idx = idx+1;
        day = tradingTable.EntryTime(i,3);
    end
end

% number of trades per day
nTrades = [cumTrades(1); diff(cumTrades)];

% remove zeroes
I = (equity~=0);
dates = dates(I,:);
nTrades = nTrades(I);
equity = equity(I);

% calculate daily returns
r = [0; (equity(2:end)-equity(1:end-1))./equity(1:end-1)];

cnames = {'Date','nTrades','Equity','Return'};
dailyTradingTable = table(dates,nTrades,equity,r,...
    'VariableNames',cnames);

disp('DONE!');
toc;
end

