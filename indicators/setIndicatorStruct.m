function [] = setIndicatorStruct()
% creates a global struct which holds variables needed in indicators
    global IndicatorStruct;
    IndicatorStruct.control = 0;
    IndicatorStruct.buyPrice = nan;
    IndicatorStruct.sellPrice = nan;
    IndicatorStruct.trailingSDEV_lower = 0;
    IndicatorStruct.trailingSDEV_upper = 100;
end

