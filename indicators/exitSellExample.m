function [b] = exitSellExample(DS,i,DScompr,k,buyPrice)
    b = (DScompr.ask_open(k-1)<DScompr.ask_open(k));
end

