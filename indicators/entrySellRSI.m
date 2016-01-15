function [b] = entrySellRSI(DS1,i,DS2,k,deltaRSI)
    b=(DS1.sellRSI_14(i)>0.7 && (DS1.sellRSI_14(i)-DS1.sellRSI_30(i))<deltaRSI);
end
