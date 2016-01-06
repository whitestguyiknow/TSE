function [preDS] = preprocessTable(dataTable)
    disp('preprocessing table..'); 
    TF = ismissing(dataTable,{'' '.' 'NA' NaN});
    dataTable = dataTable(~any(TF,2),:);
    
    M = zeros(size(dataTable) - [0 1]);
    M(:,1) = datenum(dataTable.time,'yyyy.mm.dd HH:MM:SS.FFF');
    M(:,2:3) = dataTable{:,2:3};
    M(:,4) = dataTable.ask-dataTable.bid;
      
    preDS = dataset({M 'time','bid','ask','spread'});
    preDS((preDS.spread<0),:) = []; %remove negative spreads;
    preDS.time = datevec(preDS.time);
    disp('DONE!');
end 