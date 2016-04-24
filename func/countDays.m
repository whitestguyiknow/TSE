function [nDays] = countDays(startDate,endDate)
    nDays = floor(sum((endDate-startDate).*[252,21,1,0,0,0])*5/7);
end
