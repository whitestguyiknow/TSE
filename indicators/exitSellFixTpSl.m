function [b] = exitSellFixTpSl(DS1,i,tp,sl)
%exit short if one of the following conditions are met:
%   CurrentPrice <= EntryPrice*(1-tp) %take profit
%   CurrentPrice >= EntryPrice*(1+sl) %stop loss
global IndicatorStruct; % holds trailing stop-loss and take-profit
b =     DS1.LOW_bid(i) <= IndicatorStruct.sellPrice*(1-tp) ||...
        DS1.HIGH_bid(i) >= IndicatorStruct.sellPrice*(1+sl);
end
