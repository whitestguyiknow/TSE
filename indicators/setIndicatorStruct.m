function [] = setIndicatorStruct()
% creates a global struct which holds variables needed in indicators
    global IndicatorStruct;
    IndicatorStruct = struct('buyPrice',nan,'sellPrice',nan);
end

