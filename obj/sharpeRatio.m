function [s] = sharpeRatio(dailyTradingTable)
% computes Sharpe-ratio from dailyTradingTable
% taking into account standard deviation of all returns 
% taking mean of all returns
% Important: Independent of Duration (First day -> last day)
% TODO: taking into account duration (check)

s = mean(dailyTradingTable.Return)/std(dailyTradingTable.Return);


end

