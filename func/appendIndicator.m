function [DS] = appendIndicator(DS,sys_par,name,f,varargin)
    assert(strcmp(class(f),'function_handle'), 'f must be a function handle');
    assert(strcmp(class(DS),'dataset'), 'DS must be a dataset');
    assert(ischar(name), 'name must be a string');
    
    l = length(DS.time);
    indicator = zeros(l,1);
    
    % calculate additional indicator
    for i=sys_par.tInit:l
        indicator(i) = f(DS,i,varargin{:});
    end
    
    % append to dataset
    DS.indicator = indicator;
    DS.Properties.VarNames(end)={name};
end

