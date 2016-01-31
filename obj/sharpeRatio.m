function [s] = sharpeRatio(dailyTradingTable)
% computes Sharpe-ratio from dailyTradingTable
% taking into account standard deviation of all returns 
% taking mean of all returns
% Important: Independent of Duration (First day -> last day)
% TODO: taking into account duration (check)

if isempty(dailyTradingTable)
    s=-99;
elseif dailyTradingTable.Equity(end)<1
    s = -99;
else
    s = mean(dailyTradingTable.Return)/std(dailyTradingTable.Return);
end

end

