function [Time, Action] = buildActionMatrix(DS, DScompr1, DScompr2, dtInit, fEntryBuy, fExitBuy, fEntrySell, fExitSell)
    % Parameters:
    % DS, created with function tcompressMat
    % dtInit, time-leap, must be greater than all lookback timespans in f's
    
    % fEntryBuy, function handle taking dataTable and i as input
    % fExitBuy, function handle taking dataTable, i and buyprice as input
    % fEntrySell, function handle taking dataTable and i as input
    % fExitSell, function handle taking dataTable, i and buyprice as input

    % Assertions:
    %assert(isfield(DScompr,'time'));
    %assert(isfield(DScompr,'bid_open'));
    %assert(isfield(DScompr,'ask_open'));
    %assert(isfield(DScompr,'bid_close'));
    %assert(isfield(DScompr,'ask_close'));
    
    N = length(DS.time);

    Action = zeros(N,1);    % vector storing actions: buy = 1, sell = -1
    Time = zeros(N,1);      % vector storing tradign times
    
    control = 0;            % control variable: are we long (1)? short(-1)?
    buyPrice = -1;          % parameter for fExitBuy (stoploss/takeprofit)
    sellPrice = -1;         % parameter for fExitSell (stoploss/takeprofit)
    
    for i=dtInit:N
        
        k = find(DScompr1.time>DS.time(i),1) -1;
        l = find(DScompr2.time>DS.time(i),1) -1;
        
        % go flat - sell 
        if(control == 1 & fExitBuy(DS,i,DScompr1,k,DScompr2,l,buyPrice))
            Time(i) = DS.time(i);
            Action(i) = -1;
            control = 0;
            buyPrice = -1;
            continue;
        end
        
        % go flat - buy 
        if((control == -1) & fExitSell(DS,i,DScompr1,k,DScompr2,l,sellPrice))
            Time(i) = DS.time(i);
            Action(i) = 1;
            control = 0;
            sellPrice = -1;
            continue;
        end
        
        % go long
        if(control == 0 & fEntryBuy(DS,i,DScompr1,k,DScompr2,l) && ~fExitBuy(DS,i,DScompr1,k,DScompr2,l,buyPrice) && ~fEntrySell(DS,i,DScompr1,k,DScompr2,l))
            Time(i) = DS.time(i);
            Action(i) = 1;
            control = 1;
            buyPrice = DS.ask(i+1);
            continue;
        end
        
        % go short
        if(control == 0 & fEntrySell(DS,i,DScompr1,k,DScompr2,l) & ~fExitSell(DS,i,DScompr1,k,DScompr2,l,sellPrice) & ~fEntryBuy(DS,i,DScompr1,k,DScompr2,l))
            Time(i) = DS.time(i);
            Action(i) = -1;
            control = -1;
            sellPrice = DS.bid(i+1);
            continue;
        end

    end
    
    % go flat (if needed)
    if(control == 1)
        Time(end) = DScompr1.time(end);
        Action(end) = -1;
    elseif (control == -1)
        Time(end) = DScompr1.time(end);
        Action(end) = 1;
    end
    
    % only return actions
    Time(Time == 0) = [];
    Action(Action == 0) = [];
    
    % Final Assertions:
    assert(mod(length(Action),2)==0);
    assert(length(Time)==length(Action)); 
    assert(all(Action(1:2:end-1)+Action(2:2:end))==0);
  
    
end

