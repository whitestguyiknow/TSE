function [b] = exitBuyFlexTpSl(DS1,i, k1, k2, n)
%Flexible stop loss and take profit
%exit SHOOOOOOOOOORT if one of the following conditions are met:
%   Price(t) >= max(FlexTP(t-1),BBuppr(t))
%   Price(t) <= max(FlexSL(t-1),BBlowr(t))
global IndicatorStruct;

%% flex TP, SL
winInd = (IndicatorStruct.indexLastAction-n+1:IndicatorStruct.indexLastAction);
FlexTP = mean(DS1.MED_bid(winInd))+k1*std(DS1.MED_bid(winInd));
FlexSL = mean(DS1.MED_bid(winInd))-k2*std(DS1.MED_bid(winInd));
for jj = IndicatorStruct.indexLastAction+1:i;
    winInd = (jj-n+1:jj); %indexes of current window
    BB_uppr_k1 = mean(DS1.MED_bid(winInd))+k1*std(DS1.MED_bid(winInd));
    BB_lowr_k2 = mean(DS1.MED_bid(winInd))-k2*std(DS1.MED_bid(winInd));
    FlexTP = max(BB_uppr_k1,FlexTP);
    FlexSL = max(BB_lowr_k2,FlexSL);
end

%% exit rule
b =     DS1.HIGH_bid(i) >=  FlexTP ||...
        DS1.LOW_bid(i) <=   FlexSL;
end
