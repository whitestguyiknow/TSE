function [dataTable] = loadData(datCsv)
    disp('reading table from csv file..');
    dataTable = readtable(datCsv,'ReadVariableNames',false,'ReadRowNames',false,...
    'TreatAsEmpty',{'.','NA'});
       
    cnames = {'time','bid','ask','size_bid','size_ask'};
    dataTable.Properties.VariableNames = cnames;
    disp('DONE!');
end