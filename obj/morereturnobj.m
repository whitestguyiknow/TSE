function [s] = morereturnobj(intradaytradingtable)
% Performance oriented fitness
% computes fitness from every trade
% taking into account standard deviation of all returns 
% taking mean of all returns


if(isempty(intradaytradingtable))
    s=-99;
else
    s = mean(intradaytradingtable.Return)^2/std(intradaytradingtable.Return)*sqrt(height(intradaytradingtable);
end

end

