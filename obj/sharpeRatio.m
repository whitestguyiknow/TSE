function [s] = sharpeRatio(dailyTradingTable,nDays,sys_par)
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
    s = -1e4; %no trades
    return
end

if dailyTradingTable.Equity(end)<1
    s = -1e4-1; %equity shrunk below 0
elseif nDays*sys_par.minTradesPerDay>sum(dailyTradingTable.nTrades)
    s = -1e4+1; %not enough trades, we expect one trade p day
elseif nDays*sys_par.maxTradesPerDay<sum(dailyTradingTable.nTrades)
    s = -1e4+2; %too many trades, we expect one trade p day
else
    mu = sum(dailyTradingTable.Return)/nDays;
    variance = sum(dailyTradingTable.Return.^2)/nDays - mu^2;
    s = mu/sqrt(variance)*sqrt(252);
end

end
