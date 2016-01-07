function [tcompDS] = tcompressMat(D, dt, varargin)
    % dt [mins]
    disp('compressing matrix..');
    tic;
    D.time = datenum(D.time);
    nvarargin = length(varargin);
    variableNames = D.Properties.VarNames;
    if(~iscellstr(varargin))
        error('optional arguments must be of type char');
    end
    if (~isempty(varargin))
        colIdx = zeros(1,nvarargin);
        for i=1:nvarargin
            colIdx(i) = find(strcmp(variableNames, varargin{i}));
        end
    end
    
    l=length(D.time);
    d=(D.time-D.time(1))*86400/60;
    idxOpen = false(l,1); idxOpen(1)=true;
    t = dt;
    M = double(D);
    C = 99999*ones(1,nvarargin);
    tmp_max = -C;
    tmp_min = +C;
    
    max_Mat = zeros(l,nvarargin);
    min_Mat = max_Mat;
    med_Mat = max_Mat;
    
    lastFrameIdx = 1;
    for i=2:l
        tmp_max(M(i,colIdx)>tmp_max) = M(i,colIdx(M(i,colIdx)>tmp_max));
        tmp_min(M(i,colIdx)<tmp_min) = M(i,colIdx(M(i,colIdx)<tmp_min));
        if(d(i)>=t)
            idxOpen(i)=true;
            max_Mat(i,:) = tmp_max;
            min_Mat(i,:) = tmp_min;
            med_Mat(i,:) = median(M(lastFrameIdx:i,colIdx),1);
            tmp_max = -C;
            tmp_min = C;
            lastFrameIdx = i;
            t = t+dt;
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
    disp('DONE!'); 
    toc;
end