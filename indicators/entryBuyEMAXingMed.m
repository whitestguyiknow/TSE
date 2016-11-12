function [b] = entryBuyEMAXingMed(DS1,i,x,y)
    EMAx = tsmovavg(DS1.MED_ask(1:i),'e',x,1); %short EMA
    EMAxy = tsmovavg(DS1.MED_ask(1:i),'e',x+y,1); %long EMA % y nicht < 0
    b = EMAx(end) > EMAxy(end) && EMAx(end-1) <= EMAxy(end-1);
end

