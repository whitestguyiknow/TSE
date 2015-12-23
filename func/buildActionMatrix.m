function [Time, Action] = buildActionMatrix(DS, dtInit, fEntryBuy, fExitBuy, fEntrySell, fExitSell)
    % Parameters:
    % data set, created with function tcompressMat
    % dtInit, time-leap, must be greater than all lookback timespans in f's
    
    % fEntryBuy, function handle taking dataTable and i as input
    % fExitBuy, function handle taking dataTable, i and buyprice as input
    % fEntrySell, function handle taking dataTable and i as input
    % fExitSell, function handle taking dataTable, i and buyprice as input

    % Assertions:
    assert(isfield(DS,'time'));
    assert(isfield(DS,'bid_open'));
    assert(isfield(DS,'ask_open'));
    assert(isfield(DS,'bid_close'));
    assert(isfield(DS,'ask_close'));
    
    N = length(DS.time);

    Action = zeros(N,1);    % vector storing actions: buy = 1, sell = -1
    Time = zeros(N,1);      % vector storing tradign times
    
    control = 0;            % control variable: are we long (1)? short(-1)?
    buyPrice = -1;          % parameter for fExitBuy (stoploss/takeprofit)
    sellPrice = -1;         % parameter for fExitSell (stoploss/takeprofit)
    
    for i=dtInit:N
        
        % go flat - sell 
        if(control == 1 && fExitBuy(DS,i,buyPrice))
            Time(i) = DS.time(i);
            Action(i) = -1;
            control = 0;
            buyPrice = -1;
            continue;
        end
        
        % go flat - buy 
        if(control == -1 && fExitSell(DS,i,sellPrice))
            Time(i) = DS.time(i);
            Action(i) = 1;
            control = 0;
            sellPrice = -1;
            continue;
        end
        
        % go long
        if(control == 0 && fEntryBuy(DS,i) && ~fExitBuy(DS,i,buyPrice) && ~fEntrySell(DS,i))
            Time(i) = DS.time(i);
            Action(i) = 1;
            control = 1;
            buyPrice = DS.ask_open(i+1);
            continue;
        end
        
        % go short
        if(control == 0 && fEntrySell(DS,i) && ~fExitSell(DS,i,sellPrice) && ~fEntryBuy(DS,i))
            Time(i) = DS.time(i);
            Action(i) = -1;
            control = -1;
            sellPrice = DS.bid_open(i+1);
            continue;
        end

    end
    
    % go flat (if needed)
    if(control == 1)
        Time(end) = DS.time(end);
        Action(end) = -1;
    elseif (control == -1)
        Time(end) = DS.time(end);
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

