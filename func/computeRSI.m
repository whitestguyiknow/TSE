function [rsiIndex] = computeRSI(vec,windowLength,sys_par)
    if sys_par.echo
        disp('compute RSI..');
    end
    
    N = length(vec);
    d = [0; diff(vec)];
    sup = zeros(N,1); sdn = zeros(N,1);
    for i=windowLength:N
        sup(i)=sum(max(d(i-windowLength+1:i),0));
        sdn(i)=-sum(min(d(i-windowLength+1:i),0));
    end
    rsiIndex = sup./(sup+sdn);
    rsiIndex(isnan(rsiIndex))=0.5;
    
    if sys_par.echo
        disp('DONE!');
    end
end