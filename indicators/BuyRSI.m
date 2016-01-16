function [RSI] = BuyRSI(DS,i,t1)
% calculate RSI with ask values
l = 1:t1;
sum_up = sum(max(DS.ask_close(i-l+1)-DS.ask_close(i-l),0));
sum_down = -sum(min(DS.ask_close(i-l+1)-DS.ask_close(i-l),0));

RSI = sum_up/(sum_up+sum_down);

end
