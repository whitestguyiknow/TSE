function [fObj,par] = DEoptim(func,optimStruct,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function: Optimization with Differential Evolution           
% created by Daniel, December 2015
%
% Last update: 2016 Jan 29, by Daniel
%   2016-01-29: (Daniel)
%       1. parallelization with parfor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% print progress
echo = true;

rng(optimStruct.seed);
nDim    = length(varargin);
nAgents = optimStruct.nAgents;
maxIter = optimStruct.maxIter;
CR      = optimStruct.crossOverProbability;
F       = optimStruct.differentialWeight;

write_Par = false;
load_Par = false;

if(~isempty(varargin) && ischar(varargin{nDim}))
    fileName = ['./dat/',varargin{nDim}];
    write_Par = true;
    nDim = nDim-1;
    try
        % load from previous run
        loaded_Par = dlmread(fileName, ',', 3, 0);
        load_Par = true;
    catch
        % print new file
        file = fopen(fileName,'wt');
        fprintf(file,'func %s\n', func2str(func));
        fprintf(file,'nDim %i\n',nDim);
        fprintf(file,'nAgents %i\n',nAgents);
        fclose(file);
    end
end

dims   = 1:nDim;
agents = 1:nAgents;

bounds = zeros(nDim,2);
lower = zeros(nDim,1);
upper = zeros(nDim,1);
b = zeros(nDim,1);
fObj = zeros(nAgents,1);

parallel = start_cores(optimStruct.N_cpu);
if parallel
    fprintf('running optimization using %d cpus\n',optimStruct.N_cpu);
else
    fprintf('running optimization serial\n');
end

% extract parameter bounds
for i = 1:nDim
    bounds(i,:) = varargin{i};
    lower(i) = min(bounds(i,:));
    upper(i) = max(bounds(i,:));
    b(i) = upper(i)-lower(i,1);
    assert(b(i)>0,'upper bound - lower bound must be greater than 0');
end

CRmat = repmat(CR,nAgents,nDim);

% randomly initialize parameterset
if load_Par
    par = loaded_Par(end-nAgents+1:end,dims);
    fObj = loaded_Par(end-nAgents+1:end,end);
else
    par = repmat(lower',nAgents,1) + rand(nAgents,nDim).*repmat(b',nAgents,1);
    
    if parallel
        parfor i = 1:nAgents
            fObj(i) = func(par(i,:));
        end
    else
        for i = 1:nAgents
            fObj(i) = func(par(i,:));
        end
    end
end
% initialize dimension selection
selection = repmat(agents,1,nAgents);
selection(1:nAgents+1:nAgents*nAgents)=[];
selection = reshape(selection,nAgents-1,nAgents)';

% params for progress
p=0;
frac = maxIter/100;

% optimization
for k=1:maxIter
    % print progress
    if(echo && ((k-1)>p*frac))
        disp([num2str(p), '% ..']);
        p = p+1;    %buggy if N small
    end
    
    % preparing random selection
    r = rand(nAgents,nDim);
    R = randi(dims,nAgents,1);
    I = repmat(1:nDim,nAgents,1) == repmat(R,1,nDim);
    
    % select
    cDim = zeros(nAgents,nDim);
    cDim(r<CRmat) = 1;
    cDim(I) = 1;
    
    % preparing new calculations
    new_Par = par;
    new_fObj = zeros(nAgents,1);
    
    if parallel
        % process agent
        % parallel mode
        for i =1:nAgents
            abc = datasample(selection(i,:),3,'Replace',false);
            Idx = cDim(i,:)==1;
            new_Par(i,Idx) = min(max(par(abc(1),Idx)+F*(par(abc(2),Idx)-par(abc(3),Idx)),lower(Idx)),upper(Idx));
        end
        parfor i=1:nAgents
            new_fObj(i) = func(new_Par(i,:));
        end
        
    else
        % process agent
        % parallel mode
        for i=1:nAgents
            abc = datasample(selection(i,:),3,'Replace',false);
            I = cDim(i,:)==1;
            new_Par(i,I) = par(abc(1),I)+F*(par(abc(2),I)-par(abc(3),I));
            new_fObj(i) = func(new_Par(i,:));
        end
    end
    I = new_fObj<fObj;
    par(I,:) = new_Par(I,:);
    fObj(I,:) = new_fObj(I,:);
    
    if write_Par
        dlmwrite(fileName,[par,fObj],'delimiter',',','-append');
    end
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


