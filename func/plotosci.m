function [RSI MA_RSI] = rsi(vec, period, MA_lag, set)
%
%time = vec
%varargin= important Level Lines
RSI = rsindex(vec, period);
MA_RSI =tsmovavg(vec,set,MA_lag,1);


plot(vec,'-.r');
legend('RSI', 'Location', 'Northeast');

hold on
    plot(MA_RSI,'r');
     refline(0, 15);
     refline(0, 45);
     refline(0, 55);
     refline(0, 85);
 grid minor;
 hold off;
end
     
     
  