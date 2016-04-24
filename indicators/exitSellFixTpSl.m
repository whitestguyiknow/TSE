function [b] = exitSellFixTpSl(DS1,i,tp,sl)
%exit Looooooooong if one of the following conditions are met:
%   CurrentPrice <= EntryPrice*(1-tp) %stop loss
%   CurrentPrice >= EntryPrice*(1+sl) %take profit
global IndicatorStruct; % holds trailing stop-loss and take-profit
b =     DS1.LOW_bid(i) <= IndicatorStruct.buyPrice*(1-sl) ||...
        DS1.HIGH_bid(i) >= IndicatorStruct.buyPrice*(1+tp);
end
