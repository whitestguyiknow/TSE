function [Time, Action] = buildActionMatrix(DS1, DS2, DS3, dtInit, fEntryBuy, fExitBuy, fEntrySell, fExitSell)
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
    
    DS1.time = datenum(DS1.time);
    DS2.time = datenum(DS2.time);
    DS3.time = datenum(DS3.time);
    
    N = length(DS1.time);

    Action = zeros(N,1);    % vector storing actions: buy = 1, sell = -1
    Time = zeros(N,1);      % vector storing tradign times
    
    global IndicatorStruct;
    
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
        
        knext = findPrevious(DS2.time,DS1.time(i),k);
        if(~isempty(knext))
            k = knext;
        end
        
        lnext = findPrevious(DS2.time,DS1.time(i),l);
        if(~isempty(lnext))
            l = lnext;
        end
        
        % update IndicatorStruct
        updateIndicatorStruct(DS1,i,IndicatorStruct.control);
        
        % go flat - sell 
        if(IndicatorStruct.control == 1 && fExitBuy(DS1,i,DS2,k,DS3,l))
            Time(i) = DS1.time(i);
            Action(i) = -1;
            updateIndicatorStruct(DS1,i,0)
            continue;
        end
        
        % go flat - buy 
        if(IndicatorStruct.control == -1 && fExitSell(DS1,i,DS2,k,DS3,l))
            Time(i) = DS1.time(i);
            Action(i) = 1;
            updateIndicatorStruct(DS1,i,0)
            continue;
        end
        
        % go long - buy
        if(IndicatorStruct.control == 0 && fEntryBuy(DS1,i,DS2,k,DS3,l) ... 
                && ~fEntrySell(DS1,i,DS2,k,DS3,l))
            Time(i) = DS1.time(i);
            Action(i) = 1;
            IndicatorStruct.buyPrice = DS1.ask_open(i); %check correctness if open or close 
            updateIndicatorStruct(DS1,i,1)
            continue;
        end
            
        % go short - sell
        if(IndicatorStruct.control == 0 && fEntrySell(DS1,i,DS2,k,DS3,l) ... 
                && ~fEntryBuy(DS1,i,DS2,k,DS3,l))
            Time(i) = DS1.time(i);
            Action(i) = -1;
            IndicatorStruct.sellPrice = DS1.bid_open(i); %check correctness if open or close
            updateIndicatorStruct(DS1,i,-1)
            continue;
        end

    end
    
    % go flat (if needed)
    if(IndicatorStruct.control == 1)
        Time(end) = DS1.time(end);
        Action(end) = -1;
    elseif (IndicatorStruct.control == -1)
        Time(end) = DS1.time(end);
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

