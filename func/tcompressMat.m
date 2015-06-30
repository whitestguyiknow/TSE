function [tcompDS] = tcompressMat(D, dt, varargin)
    % dt [mins]
    disp('compressing matrix..');
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
    idx = zeros(l,1); idx(1)=1;
    t = dt;
    M = double(D);
    C = 99999*ones(1,nvarargin);
    tmp_max = -C;
    tmp_min = +C;
    
    max_Mat = zeros(l,nvarargin);
    min_Mat = max_Mat;
    
    for i=2:l
        tmp_max(M(i,colIdx)>tmp_max) = M(i,colIdx(M(i,colIdx)>tmp_max));
        tmp_min(M(i,colIdx)<tmp_min) = M(i,colIdx(M(i,colIdx)<tmp_min));
        if(d(i)>=t)
            idx(i)=1;
            max_Mat(i,:) = tmp_max;
            min_Mat(i,:) = tmp_min;
            tmp_max = -C; 
            tmp_min = C;
            t = d(i)+dt;
        end
    end
    M=[M(idx==1,:), max_Mat(idx==1,:), min_Mat(idx==1,:)];
    
    newVariables = cell(1,nvarargin*2);
    for i=1:nvarargin
        newVariables{i} = strcat('max_',varargin{i});
        newVariables{i+nvarargin} = strcat('min_',varargin{i});
    end
    variableNames = [variableNames,newVariables];
    tcompDS = mat2dataset(M,'VarNames',variableNames);
    disp('DONE!'); 
end