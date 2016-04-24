function [s] = morereturnobj(intradaytradingtable,nDays,sys_par)
% Performance oriented fitness
% computes fitness from every trade
% taking into account standard deviation of all returns 
% taking mean of all returns
MAR=0.0001;
if isempty(intradaytradingtable)
    s=-99;
else
    intrareturnvec= intradaytradingtable.Return;
    if isempty(intrareturnvec)
    s=-99;
    else
        for j=1:size(intrareturnvec,2) 
            returns=intrareturnvec(:,j);
            DD(:,j)=sqrt(sum(nonzeros(returns(returns<MAR)).^2))/length(nonzeros(returns(returns<MAR)));
            sort(:,j)=(mean(returns)-MAR)/DD(:,j);
        s = (((1+mean(intrareturnvec)-MAR)^1.999999)-1)/DD*sqrt(length(intrareturnvec));
    end
end

end

