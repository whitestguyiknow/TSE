function [b] = exitBuyExample(DS,i,DScompr,k)
    b = DScompr.ask_open(k-1)>DScompr.ask_open(k);
end

