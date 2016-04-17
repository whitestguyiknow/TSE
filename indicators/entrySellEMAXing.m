function [b] = entrySellEMAXing(DS1,i,x,y)
    EMAx = tsmovavg(DS1.bid_open(1:i),'e',x,1); %short EMA
    EMAy = tsmovavg(DS1.bid_open(1:i),'e',x+y,1); %long EMA
    b = EMAx(end) < EMAy(end);
end

