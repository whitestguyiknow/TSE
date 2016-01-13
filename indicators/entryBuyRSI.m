function [b] = entryBuyRSI(DS1,i,DS2,k,t1,t2,deltaRSI)
    assert(t1>t2,'second time frame must be bigger than first');

    sum_up_t1=0;
    sum_down_t1=0;
    for i = 1:t1
        sum_up_t1 = sum_up_t1 + max(DS2.ask_close(k-i+1)-DS2.ask_close(k-i),0);
        sum_down_t1 = sum_down_t1 - min(DS2.ask_close(k-i+1)-DS2.ask_close(k-i),0);
    end
    RSI_t1 = sum_up_t1/(sum_up_t1+sum_down_t1);

    sum_up_t2=0;
    sum_down_t2=0;
    for i = 1:t2
        sum_up_t2 = sum_up_t2 + max(DS2.ask_close(k-i+1)-DS2.ask_close(k-i),0);
        sum_down_t2 = sum_down_t2 - min(DS2.ask_close(k-i+1)-DS2.ask_close(k-i),0);
    end
    RSI_t2 = sum_up_t2/(sum_up_t2+sum_down_t2);
    
    b=(RSI_t2-RSI_t1)>deltaRSI;
end


