function [b] = entryBuyRSInew(DS1,i,n)
%%
% P = DS1.ask_open(i-n+1:i);
% SumU = 0;
% SumD = 0;
% for ii = 2:length(P)
%     if P(ii)-P(ii-1) > 0
%         SumU = SumU + P(ii)-P(ii-1);
%     elseif P(ii)-P(ii-1) < 0
%         SumD = SumD + P(ii)-P(ii-1);
%     end
% end
% RS = SumU/SumD;
% RSI = 100-(100*(1+RS));

RSI = rsindex(DS1.ask_close(i-n-1:i),n);
b = RSI(end)>30 && RSI(end-1) <=30;
end

