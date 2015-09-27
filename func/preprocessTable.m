function [preDS] = preprocessTable(dataTable)
    disp('preprocessing table..'); 
    TF = ismissing(dataTable,{'' '.' 'NA' NaN});
    dataTable = dataTable(~any(TF,2),:);
    
    M = zeros(size(dataTable) + [0 1]);
    M(:,1) = datenum(dataTable.time,'yyyy.mm.dd HH:MM:SS.FFF');
    M(:,2:5) = dataTable{:,2:5};
    M(:,6) = dataTable.ask-dataTable.bid;
      
    preDS = dataset({M 'time','bid','ask','size_bid','size_ask','spread'});
    preDS((preDS.spread<0),:) = []; %remove negative spreads;
    disp('DONE!');
end 