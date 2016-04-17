function [b] = exitBuyTrailingSDEV(DS1,i,DS2,k,Clow,Chigh)
global IndicatorStruct; % holds trailing stop-loss and take-profit
b = (DS1.HIGH_ask(i)>IndicatorStruct.trailingSDEV_upper*Chigh)...
    || (DS1.LOW_ask(i)<IndicatorStruct.trailingSDEV_lower*Clow);
end
