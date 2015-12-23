function [Time, Action] = buildActionMatrix(DS,DScompr, dtInit, fEntryBuy, fExitBuy, fEntrySell, fExitSell)
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
    
    N = length(DScompr.time);

    Action = zeros(N,1);    % vector storing actions: buy = 1, sell = -1
    Time = zeros(N,1);      % vector storing tradign times
    
    control = 0;            % control variable: are we long (1)? short(-1)?
    buyPrice = -1;          % parameter for fExitBuy (stoploss/takeprofit)
    sellPrice = -1;         % parameter for fExitSell (stoploss/takeprofit)
    
    for i=dtInit:N
        
        % go flat - sell 
        if(control == 1 && fExitBuy(DS,DScompr,i,buyPrice))
            Time(i) = DScompr.time(i);
            Action(i) = -1;
            control = 0;
            buyPrice = -1;
            continue;
        end
        
        % go flat - buy 
        if(control == -1 && fExitSell(DS,DScompr,i,sellPrice))
            Time(i) = DScompr.time(i);
            Action(i) = 1;
            control = 0;
            sellPrice = -1;
            continue;
        end
        
        % go long
        if(control == 0 && fEntryBuy(DScompr,i) && ~fExitBuy(DS,DScompr,i,buyPrice) && ~fEntrySell(DScompr,i))
            Time(i) = DScompr.time(i);
            Action(i) = 1;
            control = 1;
            buyPrice = DScompr.ask_open(i+1);
            continue;
        end
        
        % go short
        if(control == 0 && fEntrySell(DScompr,i) && ~fExitSell(DS,DScompr,i,sellPrice) && ~fEntryBuy(DScompr,i))
            Time(i) = DScompr.time(i);
            Action(i) = -1;
            control = -1;
            sellPrice = DScompr.bid_open(i+1);
            continue;
        end

    end
    
    % go flat (if needed)
    if(control == 1)
        Time(end) = DScompr.time(end);
        Action(end) = -1;
    elseif (control == -1)
        Time(end) = DScompr.time(end);
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

