function [out_dat] = partition(partition,data,sys_par)
% input params
% partition: 'in' or 'out'
len = length(data);
    switch partition
        case 'in'
            idx = ceil(len*sys_par.insamplePCT);
            out_dat = data(1:idx,:);
        case 'out'
            idx = floor(len*(1-sys_par.insamplePCT));
            out_dat = data(idx:end,:);
        otherwise
            error('choose correct partition, either in or out');
    end


end

