function [b] = entryBuyRSIMed(DS1,i,n)
    RSI = rsindex(DS1.MED_ask(i-97:i),n);
    b = RSI(end)>30 && RSI(end-1) <=30;
end

