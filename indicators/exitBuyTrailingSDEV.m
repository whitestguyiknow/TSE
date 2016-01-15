function [b] = exitBuyTrailingSDEV(DS1,i,DS2,k)
    global IndicatorStruct;
    b = (DS1.HIGH_ask(i)>IndicatorStruct.trailingSDEV_upper)...
        || (DS1.LOW_ask(i)<IndicatorStruct.trailingSDEV_lower);
end
