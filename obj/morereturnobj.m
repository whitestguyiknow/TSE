function [s] = morereturnobj(intradaytradingtable)
% Performance oriented fitness
% computes fitness from every trade
% taking into account standard deviation of all returns 
% taking mean of all returns
intrareturnvec= intradaytradingtable.Return;

if(isempty(intrareturnvec))
    s=-99;
else
    s = mean(intrareturnvec)^1.9999/std(intrareturnvec)*sqrt(length(intrareturnvec));
end

end

