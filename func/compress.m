function [tcompDS] = compress(DS, dt, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function: compressing dataset into frames of duration dt [mins]   
% created by Daniel, December 2015
%
% Last update: 2016 Jan 31, by Daniel
%   2016-01-31: (Daniel)
%       1. bug fixxing (problem with time leaps in data), using min max
%       functions
%   2016-01-28: (Daniel)
%       1. restructuring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if sys_par.echo
    disp('compressing matrix..');
    tic;
end

DS.time = datenum(DS.time);
nvarargin = length(varargin);
variableNames = DS.Properties.VarNames;
if(~iscellstr(varargin))
    error('optional arguments must be of type char');
end
if (~isempty(varargin))
    colIdx = zeros(1,nvarargin);
    for i=1:nvarargin
        colIdx(i) = find(strcmp(variableNames, varargin{i}));
    end
end

l=length(DS.time);
d=(DS.time-DS.time(1))*86400/60; %[min]
idxOpen = false(l,1); idxOpen(1)=true;
tCount = dt;
M = double(DS);
C = 99999*ones(1,nvarargin);

max_Mat = zeros(l,nvarargin);
min_Mat = max_Mat;
med_Mat = max_Mat;

lastFrameIdx = 1;
for i=2:l
    % next interval
    if(d(i)>=tCount)
        idxOpen(i)=true;
        max_Mat(i,:) = max(M(lastFrameIdx:i,colIdx));
        min_Mat(i,:) = min(M(lastFrameIdx:i,colIdx));
        med_Mat(i,:) = median(M(lastFrameIdx:i,colIdx));
        lastFrameIdx = i;
        % update time
        % increase time if big time leaps
        while(d(i+1)>=tCount)
            tCount = tCount+dt;
        end
    end
end

idxClose = [idxOpen(2:end);false];

Mopen = M(idxOpen,:);
Mopen = Mopen(1:end-1,:);

Mclose = M(idxClose,2:end);

Mmax = max_Mat(idxOpen,:);
Mmax = Mmax(2:end,:);
Mmin = min_Mat(idxOpen,:);
Mmin = Mmin(2:end,:);
Mmed = med_Mat(idxOpen,:);
Mmed = Mmed(2:end,:);
M=[Mopen, Mclose, Mmax, Mmin, Mmed];

newVariables = cell(1,nvarargin*2);
for i=1:nvarargin
    newVariables{i} = strcat('HIGH_',varargin{i});
    newVariables{i+nvarargin} = strcat('LOW_',varargin{i});
    newVariables{i+2*nvarargin} = strcat('MED_',varargin{i});
end

variableNames = [{'time', 'bid_open','ask_open','spread_open',...
    'bid_close','ask_close','spread_close'},newVariables];
tcompDS = mat2dataset(M,'VarNames',variableNames);
tcompDS.time = datevec(tcompDS.time);

if sys_par.echo
    disp('DONE!');
    toc;
end

end

