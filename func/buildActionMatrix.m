function [Time, Action] = buildActionMatrix(DS, DScompr1, DScompr2, dtInit, fEntryBuy, fExitBuy, fEntrySell, fExitSell)
    % Parameters:
    % DS, created with function tcompressMat
    % dtInit, time-leap, must be greater than all lookback timespans in f's
    
    % fEntryBuy, function handle taking dataTable and i as input
    % fExitBuy, function handle taking dataTable, i and buyprice as input
    % fEntrySell, function handle taking dataTable and i as input
    % fExitSell, function handle taking dataTable, i and buyprice as input

    disp('building action matrix..');
    tic;
    
    % Assertions:
    %assert(isfield(DScompr,'time'));
    %assert(isfield(DScompr,'bid_open'));
    %assert(isfield(DScompr,'ask_open'));
    %assert(isfield(DScompr,'bid_close'));
    %assert(isfield(DScompr,'ask_close'));
    
    DS.time = datenum(DS.time);
    DScompr1.time = datenum(DScompr1.time);
    DScompr2.time = datenum(DScompr2.time);
    
    N = length(DS.time);

    Action = zeros(N,1);    % vector storing actions: buy = 1, sell = -1
    Time = zeros(N,1);      % vector storing tradign times
    
    control = 0;            % control variable: are we long (1)? short(-1)?
    
    % parameter for fExitBuy (stoploss/takeprofit)
    % parameter for fExitSell (stoploss/takeprofit)
    
    k = 1;
    l = 1;
    
    p=0;
    frac = N/100;
    for i=dtInit:N
        
        if(i>p*frac)
            disp([num2str(p), '% ..']);
            p = p+1;    %buggy if N small
        end
        
        knext = findPrevious(DScompr1.time,DS.time(i),k);
        if(~isempty(knext))
            k = knext;
        end
        
        lnext = findPrevious(DScompr1.time,DS.time(i),l);
        if(~isempty(lnext))
            l = lnext;
        end
        
        % go flat - sell 
        if(control == 1 & fExitBuy(DS,i,DScompr1,k,DScompr2,l))
            Time(i) = DS.time(i);
            Action(i) = -1;
            control = 0;
            continue;
        end
        
        % go flat - buy 
        if((control == -1) & fExitSell(DS,i,DScompr1,k,DScompr2,l))
            Time(i) = DS.time(i);
            Action(i) = 1;
            control = 0;
            continue;
        end
        
        % go long
        if(control == 0 & fEntryBuy(DS,i,DScompr1,k,DScompr2,l) ... 
                & ~fExitBuy(DS,i,DScompr1,k,DScompr2,l) & ~fEntrySell(DS,i,DScompr1,k,DScompr2,l))
            Time(i) = DS.time(i);
            Action(i) = 1;
            control = 1;
            IndicatorStruct.buyPrice = DS.ask_open(i); %check correctness if open or close 
            continue;
        end
        
        % go short
        if(control == 0 & fEntrySell(DS,i,DScompr1,k,DScompr2,l) ... 
                & ~fExitSell(DS,i,DScompr1,k,DScompr2,l) & ~fEntryBuy(DS,i,DScompr1,k,DScompr2,l))
            Time(i) = DS.time(i);
            Action(i) = -1;
            control = -1;
            IndicatorStruct.sellPrice = DS.bid_open(i); %check correctness if open or close
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

    disp('DONE!'); 
    toc;
end

