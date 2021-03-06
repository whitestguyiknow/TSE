function [DS] = loadDataCsvauto(datCsv,sys_par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function: load data & preprocessing
%           return dataset           

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
   if sys_par.echo
        disp('reading table from csv file..');
        tic;
     end
    dataTable = readtable(datCsv,'ReadVariableNames',false,'ReadRowNames',false,...
    'TreatAsEmpty',{'NA'});
       
    cnames = {'time','bid','ask','size_bid','size_ask'};
    dataTable.Properties.VariableNames = cnames;
    TF = ismissing(dataTable,{'' '.' 'NA' NaN});
    dataTable = dataTable(~any(TF,2),:);
    
    M = zeros(size(dataTable) - [0 1]);
    M(:,1) = datenum(dataTable.time,'yyyy.mm.dd HH:MM:SS.FFF');
    M(:,2:3) = dataTable{:,2:3};
    M(:,4) = dataTable.ask-dataTable.bid;
      
    DS = dataset({M 'time','bid','ask','spread'});
    DS((DS.spread<0),:) = []; %remove negative spreads;
    DS.time = datevec(DS.time);
    
     if sys_par.echo
         disp('DONE!');
         toc;
     end
end