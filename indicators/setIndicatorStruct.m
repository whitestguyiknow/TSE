function [] = setIndicatorStruct()
% creates a global struct which holds variables needed in indicators
    global IndicatorStruct;
    IndicatorStruct = struct('buyPrice',nan,'sellPrice',nan,...
        'trailingSDEV_lower',0,'trailingSDEV_upper',0);
end

