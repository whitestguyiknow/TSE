function [dailyTradingTable] = buildDailyTradingTable(tradingTable)
    disp('building daily trading table..');
    tic;
    
    tradingIntervall = tradingTable.ExitTime(end,:) - tradingTable.EntryTime(1,:);
    M = 365*tradingIntervall(1)+30*tradingIntervall(2)+tradingIntervall(3);
    
    dates     = zeros(M,3);
    cumTrades = zeros(M,1);
    equity    = zeros(M,1);
    
    idx=1;
    day = tradingTable.EntryTime(1,3);
    for i = 2:length(tradingTable.ExitTime)
        if(tradingTable.ExitTime(i,3)~=day)
            dates(idx,:)     = tradingTable.ExitTime(i-1,1:3);
            equity(idx)    = tradingTable.Equity(i-1);
            cumTrades(idx) = i;
            idx = idx+1;
            day = tradingTable.EntryTime(i+1,3);
        end     
    end
    
    nTrades = [cumTrades(1); diff(cumTrades)];
    
    I = (equity~=0);
    
    dates = dates(I,:);
    nTrades = nTrades(I);
    equity = equity(I);
    
    r = [1; diff(equity)./equity(1:end-1)];
    
    cnames = {'Date','nTrades','Equity','Return'};
    dailyTradingTable = table(dates,nTrades,equity,r,...
        'VariableNames',cnames);
    
    disp('DONE!'); 
    toc;
end

