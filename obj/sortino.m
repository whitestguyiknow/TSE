function [sort] = sortino(dailyTradingTable)
% Computes Sortino ratio
% Input: DailyTradingtable


%Output sortino Ratio


if(isempty(dailyTradingTable))
    sort=-99;
else
for j=1:size(dailyTradingTable.Return,2) 
    
F=dailyTradingTable.Return(:,j);

%%Possible to enhance ...always size changing
DD(:,j)=sqrt(sum(nonzeros(F(F<0)).^2))/length(nonzeros(F(F<0)));
sort(:,j)=(mean(F)-MAR)/DD(:,j);
   
end

end