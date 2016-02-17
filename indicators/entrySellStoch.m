function [b] = entrySellStoch(DS1,i,DS2,k,LB,x)
T = round(x);

L1 = min(DS1.LOW_ask(i-T:i));
H1 = max(DS1.HIGH_ask(i-T:i));
stoch_X1 = (DS1.ask_close(i)-L1)/(H1-L1);

L2 = min(DS1.LOW_ask(i-LB-T:i-LB));
H2 = max(DS1.HIGH_ask(i-LB-T:i-LB));
stoch_X2 = (DS1.ask_close(i)-L2)/(H2-L2);

if isempty(L1) || isempty(L2)
    b=false;
else
    b=(stoch_X1<0.4 && stoch_X2>0.4);
end

end


