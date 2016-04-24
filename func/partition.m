function [dataOut] = partition(data_pre,data_t,sys_par)
%[data_t_is, data_t_os, data_pre_is, data_pre_os] = partition(data_pre,data_t,sys_par)
%INPUTS:
%   data_pre:       tick data
%   data_t:         compressed data
%   sys_par:        system parameter struct from getSysPar()
%OUTPUTS:
%   dataOut:        struct consisting of:
%       .tIs:       in of sample data aggregated time frame
%       .tOs:       out of sample data aggregated time frame
%       .preIs:     in of sample data
%       .preOS:     out of sample data

%% partition data_pre according to defined ration in sys_par
assert(0<=sys_par.insamplePCT<=1,'sys_par.insamplePCT has to be >=0 and <=1')
l_pre = size(data_pre,1); %length of tick data
ind_pre_is = (1:1:round((l_pre+1)*sys_par.insamplePCT));
ind_pre_os = (round((l_pre+1)*sys_par.insamplePCT):1:l_pre);
if isempty(ind_pre_is);
    data_pre_is = data_pre(1,:);
    data_pre_os = data_pre(1:end,:);
elseif isempty(ind_pre_os);
    data_pre_is = data_pre(1:end,:);
    data_pre_os = data_pre(end,:);
else
    data_pre_is = data_pre(ind_pre_is,:);
    data_pre_os = data_pre(ind_pre_os,:);
end

%% partition data_t s.t. the partitions are contained in the pre partitions
last_is =   find(datenum(data_t.time) <= datenum(data_pre_is.time(end,:)),  1,'last');
first_os =  find(datenum(data_t.time) >= datenum(data_pre_os.time(1,:)),    1,'first');
data_t_is = data_t(1:last_is,:);
data_t_os = data_t(first_os:end,:);

%%set up return struct
dataOut = struct(   'preIs',data_pre_is,...
                    'preOs',data_pre_os,...
                    'tIs',data_t_is,...
                    'tOs',data_t_os);
                
end

