function [p] = profitfactor(intradaytradingtable)
% Computes Profit Factor
% Input: trade profit vector in Dollar intraday

%Output Profitfactor


if(isempty(intradaytradingtable))
    p=-99;
else
   grossloss=sum(nonzeros(intradaytradingtable.NettoPnLUSD(intradaytradingtable.NettoPnLUSD<0)));
   grossprofit=sum(nonzeros(intradaytradingtable.NettoPnLUSD(intradaytradingtable.NettoPnLUSD>0)));
   p=grossprofit/abs(grossloss);
   
end

end

