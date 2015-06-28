function [dataTable] = loadData(datCsv)
    disp('reading table from csv file..');
    dataTable = readtable(datCsv,'ReadVariableNames',false,'ReadRowNames',...
        false,'FileEncoding', 'UTF-8','TreatAsEmpty',{'.','NA'});
       
    cnames = {'time','bid','ask','size_bid','size_ask'};
    dataTable.Properties.VariableNames = cnames;
    disp('DONE!');
end