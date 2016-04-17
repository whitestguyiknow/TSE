function [b] = exitBuyFixTpSl(DS1,i,tp,sl)
%Fix stop loss and take profit
%exit long if one of the following conditions are met:
%   CurrentPrice >= EntryPrice*(1+tp) %take profit
%   CurrentPrice <= EntryPrice*(1-sl) %stop loss
global IndicatorStruct; % holds trailing stop-loss and take-profit
b =     DS1.ask_close(i) >= IndicatorStruct.buyPrice*(1+tp) ||...
        DS1.ask_close(i) <= IndicatorStruct.buyPrice*(1-sl);
end
