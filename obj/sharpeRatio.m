function [s] = sharpeRatio(dailyTradingTable,sys_par)
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
nDays = countDays(dailyTradingTable.Date(1,:),dailyTradingTable.Date(end,:));
if isempty(dailyTradingTable)
    s = -1e6; %no trades
elseif dailyTradingTable.Equity(end)<1
    s = -1e6; %equity shrunk below 0
elseif nDays*sys_par.minTradesPerDay>sum(dailyTradingTable.nTrades)
    s = -1e6; %not enough trades, we expect one trade p day
elseif nDays*sys_par.maxTradesPerDay<sum(dailyTradingTable.nTrades)
    s = -1e6; %too many trades, we expect one trade p day
else
    mu = sum(dailyTradingTable.Return)/nDays;
    variance = sum(dailyTradingTable.Return.^2)/nDays - mu^2;
    s = mu/sqrt(variance)*sqrt(252);
end

end

function [nDays] = countDays(startDaye,endDate)
    nDays = sum((endDate-startDaye).*[252,21,1]);
end