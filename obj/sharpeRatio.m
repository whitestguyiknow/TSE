function [s] = sharpeRatio(dailyTradingTable)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function: computes Sharpe-ratio from dailyTradingTable        
% created by Daniel, December 2015
%
%
% Last update: 2016 Jan 31, by Daniel
%   2016-01-31: (Daniel)
%       1. restrictions for sharpe-ratio; restructuring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isempty(dailyTradingTable)
    s=-100; %no trades
elseif dailyTradingTable.Equity(end)<1
    s = -99; %equity shrunk below 0
elseif countDays(dailyTradingTable.Date(1),dailyTradingTable.Date(end))>sum(dailyTradingTable.nTrades)
    s = -101; %not enough trades, we expect one trade p day
else
    s = mean(dailyTradingTable.Return)/std(dailyTradingTable.Return)*sqrt(252);
end

end

function [nDays] = countDays(date1,date2)
    nDays = sum((date2-date1).*[252,21,1]);
end