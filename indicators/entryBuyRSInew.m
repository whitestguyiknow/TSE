function [b] = entryBuyRSInew(DS1,i,n)
    RSI = rsindex(DS1.ask_close(i-97:i),n);
    b = RSI(end)>30 && RSI(end-1) <=30;
end

