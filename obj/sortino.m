function [sortinoRatio] = sortino(dailyTradingTable,nDays,sys_par)
% Computes Sortino ratio
% Input: DailyTradingtable

if isempty(dailyTradingTable)
    sortinoRatio = -1e4; %no trades
    return
end

if dailyTradingTable.Equity(end)<1
    sortinoRatio = -1e4-1; %equity shrunk below 0
% elseif nDays*sys_par.minTradesPerDay>sum(dailyTradingTable.nTrades)
%     sortinoRatio = -1e4+1; %not enough trades, we expect one trade p day
elseif nDays*sys_par.maxTradesPerDay<sum(dailyTradingTable.nTrades)
    sortinoRatio = -1e4+2; %too many trades, we expect one trade p day
else
    DD = sqrt(sum((dailyTradingTable.Return<0).^2)/length(dailyTradingTable.Return));
    sortinoRatio = mean(dailyTradingTable.Return)./DD*sqrt(252);
end

end