function [b] = entrySellExample(DS,DScompr,i,dt)
    b = (DScompr.ask_open(i-dt)>DScompr.ask_open(i));
end

