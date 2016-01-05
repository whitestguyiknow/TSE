function [b] = exitSellExample(DS,DScompr,i,buyPrice)
    b = (DScompr.ask_open(i-1)<DScompr.ask_open(i));
end

