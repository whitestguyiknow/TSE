function [] = updateIndicatorStruct(DS,i,control)
     global IndicatorStruct;
     IndicatorStruct.control = control;
     
     % if long
     if(IndicatorStruct.control == 1)
        if(DS.bid_close(i)+30*DS.sdev(i)<IndicatorStruct.trailingSDEV_upper)
            IndicatorStruct.trailingSDEV_upper = DS.bid_close(i)+DS.sdev(i);
        elseif(DS.bid_close(i)-10*DS.sdev(i)>IndicatorStruct.trailingSDEV_lower)
            IndicatorStruct.trailingSDEV_lower = DS.bid_close(i)-DS.sdev(i);
        end
         
     % if short
     elseif(IndicatorStruct.control == -1)
        if(DS.ask_close(i)+10*DS.sdev(i)<IndicatorStruct.trailingSDEV_upper)
            IndicatorStruct.trailingSDEV_upper = DS.ask_close(i)+DS.sdev(i);
        elseif(DS.ask_close(i)-30*DS.sdev(i)>IndicatorStruct.trailingSDEV_lower)
            IndicatorStruct.trailingSDEV_lower = DS.ask_close(i)-DS.sdev(i);
        end
     
     % if flat
     else
         IndicatorStruct.trailingSDEV_lower = 0;
         IndicatorStruct.trailingSDEV_upper = DS.bid_close(i)+1000*DS.sdev(i);
     end
end

