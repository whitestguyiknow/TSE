function [s] = morereturnobjvs2(intradaytradingtable,nDays,sys_par)
% Performance oriented fitness
% computes fitness from every trade
% taking into account standard deviation of all returns 
% taking mean of all returns
if isempty(intradaytradingtable)
    s = -1e2-2; %no trades
    return
end

    intrareturnvec= intradaytradingtable.Return;
nDays = countDays(intradaytradingtable.EntryTime(1,:),intradaytradingtable.ExitTime(end,:));

if nDays*sys_par.minTradesPerDay>length(intrareturnvec);
    s = -1e2-1; %not enough trades, we expect one trade p day
elseif nDays*sys_par.maxTradesPerDay<length(intrareturnvec);
    s = -1e2+1; %too many trades, we expect one trade p day
else
        s = (((1+mean(intrareturnvec)).^sys_par.alpha)-1)/std(intrareturnvec)*sqrt(length(intrareturnvec));
end

end
