function [Time,Position] = getExampleTrades(N,timeSeries)
    % returns an example Trade record for testing
    % N trades
    % timeSeris to sample from
    L = length(timeSeries);
    i = 1:L;
    idx = datasample(i,N,'Replace',false);
    idx = sort(idx);
    action=[ones(1,ceil(N*0.5)); -ones(1,ceil(N*0.5))];
    action=action(:);
    Time = timeSeries(idx);
    Position = action(1:N);
end

