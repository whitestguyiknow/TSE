function [p] = profitfactor(intradaytradingtable)
% Computes Profit Factor
% Input: trade profit vector in Dollar

%Output Profitfactor


if(isempty(intradaytradingtable))
    p=-99;
else
   grossloss=sum(nonzeros(intradaytradingtable(intradaytradingtable<0)));
   grossprofit=sum(nonzeros(intradaytradingtable(intradaytradingtable>0)));
   p=grossprofit/grossloss;
   
end

end

