function [b] = exitSellTrailingSDEV(DS1,i,DS2,k,dt)
    global IndicatorStruct;
    sdev = std(DS1.bid_close(i-dt:i));
    b = (DS1.bid_close(i)<IndicatorStruct.trailingSDEV_lower);
    if (DS1.bid_close(i)-sdev)>IndicatorStruct.trailingSDEV_lower
        IndicatorStruct.trailingSDEV_lower = DS1.bid_close(i)-sdev;
    end
end

