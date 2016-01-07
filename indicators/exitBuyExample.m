function [b] = exitBuyExample(DS,i,DScompr,k,infoStruct)
    b = DScompr.ask_open(k-1)>DScompr.ask_open(k);
end

