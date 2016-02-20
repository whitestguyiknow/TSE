function [idx] = findPrevious(arr,dat,start)
    idx = find(arr(start:end)>dat,1)-1;
    idx = idx+start-1;
    if idx==0 %check that
        idx=1;
    end
end

