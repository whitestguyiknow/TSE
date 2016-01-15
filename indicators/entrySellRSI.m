function [b] = entrySellRSI(DS1,i,DS2,k,t1,t2,deltaRSI)
    assert(t1<t2,'second time frame must be bigger than first');

    sum_up_t1=0;
    sum_down_t1=0;
    for l = 1:t1
        sum_up_t1 = sum_up_t1 + max(DS1.bid_close(i-l+1)-DS1.bid_close(i-l),0);
        sum_down_t1 = sum_down_t1 - min(DS1.bid_close(i-l+1)-DS1.bid_close(i-l),0);
    end
    RSI_t1 = sum_up_t1/(sum_up_t1+sum_down_t1);

    sum_up_t2=0;
    sum_down_t2=0;
    for l = 1:t2
        sum_up_t2 = sum_up_t2 + max(DS1.bid_close(i-l+1)-DS1.bid_close(i-l),0);
        sum_down_t2 = sum_down_t2 - min(DS1.bid_close(i-l+1)-DS1.bid_close(i-l),0);
    end
    RSI_t2 = sum_up_t2/(sum_up_t2+sum_down_t2);
    
    b=(RSI_t1>0.7 && (RSI_t1-RSI_t2)<deltaRSI);
end
