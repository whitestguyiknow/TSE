function [RSI] = SellRSI(DS,i,t1)
% calculate RSI with bid values
range = 1:t1;
sum_up = sum(max(DS.bid_close(i-range+1)-DS.bid_close(i-range),0));
sum_down = -sum(min(DS.bid_close(i-range+1)-DS.bid_close(i-range),0));

RSI = sum_up/(sum_up+sum_down);

end

