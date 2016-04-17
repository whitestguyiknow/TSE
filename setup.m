function [] = setup()
    format long;
    N_cpu = 1;
    %N_cpu = feature('numCores'); %gibt die maximale Anzahl Kerne auf dem
    %System wieder
    addpath('func', ...
        'dat', ...
        'indicators', ...
        'optimize', 'optimize/DE','optimize/CMA', ...
        'obj', ...
        'plots', ...
        'spread',...
        'plotfunc');
    
    if N_cpu > 1
        start_cores(N_cpu);
    end
    
end

function [b] = start_cores(N_cpu)
b = true;
if N_cpu > 1
    max_trial = 100;
    tmp = 1;
    tmp_par = gcp('nocreate');
    while (isempty(tmp_par) || (tmp_par.NumWorkers < N_cpu))...
            && (tmp < max_trial)
        try
            tmp_par = parpool('local',N_cpu);
        catch
            tmp = tmp + 1;
        end
        
    end
    if tmp == max_trial
        fprintf('matlabpool open failed %d times\n',max_trial)
        b = false;
    end
end
end