function [b] = entrySellRSIMed(DS1,i,n)
RSI = rsindex(DS1.MED_ask(i-97:i),n);
b = RSI(end)<70 && RSI(end-1) >=70;
end

