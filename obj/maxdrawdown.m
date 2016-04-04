function [ ddRel] = maxdrawdown(intradaytradingtable)
% MUSSS Verbessert werden 
%Calculates the maximum relative drawdown of (intraday)Tradingtable
% INPUTS:
% returnvector...  time-series vector
%
% OUTPUTS:
% ddRel   ... Maximum drawdown (relative)
% ddTrades ... How many trades for recovery
tradereturnvec= intradaytradingtable.Return;
 n = length(tradereturnvec);
 cr = zeros(n,1);% coumpounded return vector
 
  % in sample
    cr(1)= tradereturnvec(1)+1;
    for i= 2:n
        cr(i)=(cr(i-1))*(1+tradereturnvec(i));
    end

mymax = -inf;
ddRel = 0;

for j = 1:n
    if cr(j) > mymax
        mymax = cr(j);
        lastmax = j;
    end
    dd = 1-(cr(j)/mymax);
    if dd > ddRel
        ddRel = dd;
        ddStart = lastmax;
        ddEnd = j;
        ddTrades =ddStart-ddEnd;
    end
end
ddRel=ddRel*(-1);