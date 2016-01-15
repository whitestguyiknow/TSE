function [DS] = appendIndicator(DS,f,name)
    assert(strcmp(class(f),'function_handle'), 'f must be a function handle');
    assert(strcmp(class(f),'dataset'), 'DS must be a dataset');
    assert(ischar(name), 'name must be a string');
    DS.indicator = f(DS);
    DS.Properties.VarNames(end)={name};
end

