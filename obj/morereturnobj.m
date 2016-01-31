function [s] = morereturnobj(intrareturnvec)
% Performance oriented fitness
% computes fitness from every trade
% taking into account standard deviation of all returns 
% taking mean of all returns


if(isempty(intrareturnvec))
    s=-99;
else
    s = mean(intrareturnvec)^1.99999999999999999999999999/std(intrareturnvec)*sqrt(length(intrareturnvec));
end

end

