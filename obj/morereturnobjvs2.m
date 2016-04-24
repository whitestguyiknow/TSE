function [s] = morereturnobjvs2(intradaytradingtable,sys_par)
% Performance oriented fitness
% computes fitness from every trade
% taking into account standard deviation of all returns 
% taking mean of all returns
if isempty(intradaytradingtable)
    s = -1e6; %no trades
    return
end

    intrareturnvec= intradaytradingtable.Return;
nDays = countDays(intradaytradingtable.EntryTime(1,:),intradaytradingtable.ExitTime(end,:));

if nDays*sys_par.minTradesPerDay>length(intrareturnvec);
    s = -1e6; %not enough trades, we expect one trade p day
elseif nDays*sys_par.maxTradesPerDay<length(intrareturnvec);
    s = -1e6; %too many trades, we expect one trade p day
else
        for j=1:size(intrareturnvec,2) 
            returns=intrareturnvec(:,j);
            DD(:,j)=sqrt(sum(nonzeros(returns(returns<sys_par.MAR)).^2))/length(nonzeros(returns(returns<MAR)));
            sort(:,j)=(mean(returns)-sys_par.MAR)/DD(:,j);
        s = (((1+mean(intrareturnvec)-sys_par.MAR)^sys_par.alpha)-1)/DD*sqrt(length(intrareturnvec));
        end
end

end

function [nDays] = countDays(startDate,endDate)
    nDays = sum((endDate-startDate).*[252,21,1]);
end