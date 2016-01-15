function [b] = exitSellTrailingSDEV(DS1,i,DS2,k)
    global IndicatorStruct;
    b = (DS1.HIGH_bid(i)>IndicatorStruct.trailingSDEV_upper)...
        || (DS1.LOW_bid(i)<IndicatorStruct.trailingSDEV_lower);
end

