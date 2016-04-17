function [b] = entrySellStoch(DS1,i,DS2,k,LBslow,LBshort)
% Stochastic Oscillator Optim Params
% LBslow    additional "lookback" time for slow stoch. osc. (must be int)
% LBshort   short "lookback" time (must be int)

LBslow = round(LBslow); % sometimes CMA does not generate exact ints
LBshort = round(LBshort); % "

L1 = min(DS1.LOW_ask(i-LBshort:i));
H1 = max(DS1.HIGH_ask(i-LBshort:i));
stoch_X1 = (DS1.ask_close(i)-L1)/(H1-L1);

L2 = min(DS1.LOW_ask(i-LBslow-LBshort:i)); % or i-LBslow??
H2 = max(DS1.HIGH_ask(i-LBslow-LBshort:i)); % or i-LBslow??
stoch_X2 = (DS1.ask_close(i)-L2)/(H2-L2);

if isempty(L1) || isempty(L2)
    b=false;
else
    b=(stoch_X1<0.4 && stoch_X2>0.4);
end


end


