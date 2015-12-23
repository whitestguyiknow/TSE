function [b] = entrySellExample(DS,i,dt)
    b = (DS.ask_open(i-dt)>DS.ask_open(i));
end

