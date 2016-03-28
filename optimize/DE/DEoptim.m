function [fObj,par] = DEoptim(fitfun,inOpts,varargin)
CMAoptim( ...
    fitfun, ...    % name of objective/fitness function
    xstart, ...    % objective variables initial point, determines N
    insigma, ...   % initial coordinate wise standard deviation(s)
    inopts, ...    % options struct, see defopts below
    varargin )     % arguments passed to objective function 
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

rng(inOpts.seed);
nDim    = length(inOpts.dim);
nAgents = inOpts.nPopulation;
maxIter = inOpts.maxIter;
CR      = inOpts.CR;
F       = inOpts.F;

write_Par = true;
load_Par = false;

if(write_Par)
    fileName = inOpts.SaveFilename;
    try
        % load from previous run
        loaded_Par = dlmread(fileName, ',', 3, 0);
        load_Par = true;
    catch
        % print new file
        file = fopen(fileName,'wt');
        fprintf(file,'func %s\n', func2str(fitfun));
        fprintf(file,'nDim %i\n',nDim);
        fprintf(file,'nAgents %i\n',nAgents);
        fclose(file);
    end
end

dims   = 1:nDim;
agents = 1:nAgents;

fObj = zeros(nAgents,1);

if inOpts.enable_parallel
    parallel = start_cores(inOpts.N_cpu);
else
    parallel = false;
end
if parallel
    fprintf('running optimization using %d cpus\n',inOpts.N_cpu);
else
    fprintf('running optimization serial\n');
end

% extract parameter bounds
lower = inOpts.lower;
upper = inOpts.upper;
b = upper - lower;
assert(all(b>0),'upper bound - lower bound must be greater than 0');


CRmat = repmat(CR,nAgents,nDim);

% randomly initialize parameterset
if load_Par
    par = loaded_Par(end-nAgents+1:end,dims);
    fObj = loaded_Par(end-nAgents+1:end,end);
else
    par = repmat(lower',nAgents,1) + rand(nAgents,nDim).*repmat(b',nAgents,1);
    
    if parallel
        parfor i = 1:nAgents
            fObj(i) = fitfun(par(i,:));
        end
    else
        for i = 1:nAgents
            fObj(i) = fitfun(par(i,:));
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
    R = randi(nDim,nAgents,1);
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
            try %debugging
                new_Par(i,Idx) = min(max(par(abc(1),Idx)+F*(par(abc(2),Idx)-par(abc(3),Idx)),lower(Idx)),upper(Idx));
            catch
                -1;
            end
        end   
        parfor i=1:nAgents
            new_fObj(i) = fitfun(new_Par(i,:));
        end
        
    else
        % process agent
        % parallel mode
        for i=1:nAgents
            abc = datasample(selection(i,:),3,'Replace',false);
            I = cDim(i,:)==1;
            new_Par(i,I) = par(abc(1),I)+F*(par(abc(2),I)-par(abc(3),I));
            new_fObj(i) = fitfun(new_Par(i,:));
        end
    end
    % replace better values
    I = new_fObj<fObj;
    par(I,:) = new_Par(I,:);
    fObj(I,:) = new_fObj(I,:);
    % sort them
    [fObj,Is] = sort(fObj,'descend');
    par = par(Is,:);
    % write to file
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


