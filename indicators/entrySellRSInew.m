function [b] = entrySellRSInew(DS1,i,n)
%%
RSI = rsindex(DS1.ask_close(i-n-1:i),n);
b = RSI(end)<70 && RSI(end-1) >=70;
end

