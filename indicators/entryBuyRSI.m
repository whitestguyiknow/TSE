function [b] = entryBuyRSI(DS1,i,DS2,k,deltaRSI)
b=(DS1.buyRSI_14(i)<0.3 && (DS1.buyRSI_30(i)-DS1.buyRSI_14(i))<deltaRSI);
end


