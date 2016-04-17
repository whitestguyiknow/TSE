function [b] = entryBuyEMAXing(DS1,i,x,y)
    EMAx = tsmovavg(DS1.ask_open(1:i),'e',x,1); %short EMA
    EMAy = tsmovavg(DS1.ask_open(1:i),'e',x+y,1); %long EMA % y nicht < 0
    b = EMAx(end) > EMAy(end);
end

