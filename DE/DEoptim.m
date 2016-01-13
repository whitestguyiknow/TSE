function [fObj,par] = DEoptim(func,optimStruct,varargin)

rng(optimStruct.seed);
nDim    = length(varargin);
nAgents = optimStruct.nAgents;
maxIter = optimStruct.maxIter;
CR      = optimStruct.crossOverProbability;
F       = optimStruct.differentialWeight;

dims   = 1:nDim;
agents = 1:nAgents;

bounds = zeros(nDim,2);
lower = zeros(nDim,1);
b = zeros(nDim,1);

% extract parameter bounds
for i = 1:nDim
    bounds(i,:) = varargin{i};
    lower(i) = min(bounds(i,:));
    b(i) = abs(bounds(i,2)-bounds(i,1));
end

CRmat = repmat(CR,nAgents,nDim);

% randomly initialize parameterset
par = repmat(lower',nAgents,1) + rand(nAgents,nDim).*repmat(b',nAgents,1);

% initialize dimension selection 
selection = repmat(agents,1,nAgents);
selection(1:nAgents+1:nAgents*nAgents)=[];
selection = reshape(selection,nAgents-1,nAgents)';

% optimization
for k=1:maxIter
    fObj = func(par); % TODO: parallelize this
    new_Par = par;
    new_fObj = zeros(nAgents,1);
    r = rand(nAgents,nDim);
    R = randi(dims,nAgents,1);
    I = repmat(1:nDim,nAgents,1) == repmat(R,1,nDim);
    
    % select 
    cDim = zeros(nAgents,nDim);
    cDim(r<CRmat) = 1;
    cDim(I) = 1;
    
    % process agents
    % TODO: parallelize
    for i=1:nAgents
        abc = datasample(selection(i,:),3,'Replace',false);
        I = cDim(i,:)==1;
        new_Par(i,I) = par(abc(1),I)+F*(par(abc(2),I)-par(abc(3),I));
        new_fObj(i) = func(new_Par(i,:));
    end
   
    I = (new_fObj<fObj);
    par(I,:) = new_Par(I,:);
    fObj(I,:) = new_fObj(I,:);
end



end
