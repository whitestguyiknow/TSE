function [b] = entrySellEMAXing(DS1,i,x,y)
    EMAx = tsmovavg(DS1.ask_close(1:i),'e',x,1); %short EMA
    EMAxy = tsmovavg(DS1.ask_close(1:i),'e',x+y,1); %long EMA
    b = EMAx(end) < EMAxy(end) && EMAx(end-1) >= EMAxy(end-1);
end

