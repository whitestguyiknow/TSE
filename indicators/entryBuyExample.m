function [b] = entryBuyExample(DS,i,DScompr,k,dt)
    b = (DScompr.ask_open(k-dt)<=DScompr.ask_open(k));
end

