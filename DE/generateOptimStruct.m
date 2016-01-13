function [S] = generateOptimStruct(nAgents,maxIter,CR,F,seed)
    assert(CR>0 && CR<1,'crossover probability must be in (0,1)')
    assert(F>0 && F<2,'differential weight must be in (0,2)')
    
    S = struct('nAgents',nAgents,'maxIter',maxIter,...
        'crossOverProbability',CR,'differentialWeight',F,'seed',seed);
end

