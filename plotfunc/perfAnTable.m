function [ ] = perfAnTable( isTradingTable, isDailyTT,...
                            oosTradingTable, oosDailyTT,...
                            underlying_pre,...
                            sysName, underlying, timeStep, lengthData)
%perfAnTable()
%   Performance Analytics Table

daten = {   [datestr(isTradingTable.EntryTime(1,:),' yyyy.mm.dd HH:MM'),' - ',datestr(isTradingTable.ExitTime(end,:),' yyyy.mm.dd HH:MM')];...
            [datestr(oosTradingTable.EntryTime(1,:),' yyyy.mm.dd HH:MM'),' - ',datestr(oosTradingTable.ExitTime(end,:),' yyyy.mm.dd HH:MM')]};
        
nTrades =   [   size(isTradingTable,1);
                size(oosTradingTable,1)];
nShort =    [   length(isTradingTable.Position(isTradingTable.Position<0));
                length(oosTradingTable.Position(oosTradingTable.Position<0))];

nLong =     [   length(isTradingTable.Position(isTradingTable.Position>0));
                length(oosTradingTable.Position(oosTradingTable.Position>0))];
 
meanReturn =    [   100*mean(isTradingTable.Return);
                    100*mean(oosTradingTable.Return)];

tRatMeanReturn =    [   0;
                        0];

meanLong =          [   0;
                        0];

tRatMeanLong =      [   0;
                        0];

meanShort =         [   0;
                        0];

tRatMeanShort =     [   0;
                        0];

hitRatio =          [   0;
                        0];

maxDuration =       [   0;
                        0];

minDuration =       [   0;
                        0];

medDuration =       [   0;
                        0];

profFactor =        [   0;
                        0];

maxDD =             [   0;
                        0];

PUPRat =            [   0;
                        0];

kumReturnAnn =      [   0;
                        0];




RowNames = {    [underlying{1},' ', num2str(timeStep),' min'];
                'Anzahl Trades';
                'Anzahl Short';
                'Anzahl Long';
                'Mean Return Total [%]';
                't-Ratio Mean Total';
                'Mean Retrun Long [%]';
                't-Ratio Mean Long';
                'Mean Short [%]';
                't-Ratio Mean Short';
                'Hit Ratio';
                'Max Duration [min]';
                'Min Duration [min]';
                'Median Duration [min]';
                'Profit Factor';
                'Max DD [%]';
                'PUP-Ratio';
                'kumulierter Retrun annualisiert'};
            
InOfSample =      { daten{1};
                    nTrades(1);
                    nShort(1);
                    nLong(1);
                    meanReturn(1);
                    tRatMeanReturn(1);
                    meanLong(1);
                    tRatMeanLong(1);
                    meanShort(1);
                    tRatMeanShort(1);
                    hitRatio(1);
                    maxDuration(1);
                    minDuration(1);
                    medDuration(1);
                    profFactor(1);
                    maxDD(1);
                    PUPRat(1);
                    kumReturnAnn(1)};
                    
OutOfSample =   {   daten{2};
                    nTrades(2);
                    nShort(2);
                    nLong(2);
                    meanReturn(2);
                    tRatMeanReturn(2);
                    meanLong(2);
                    tRatMeanLong(2);
                    meanShort(2);
                    tRatMeanShort(2);
                    hitRatio(2);
                    maxDuration(2);
                    minDuration(2);
                    medDuration(2);
                    profFactor(2);
                    maxDD(2);
                    PUPRat(2);
                    kumReturnAnn(2)};
    %%            
T = table(InOfSample,OutOfSample,'RowNames',RowNames);
T.Properties.DimensionNames{1} = 'Vars';

%%
% % Print Latex table
% input.data = T;
% input.tableColumnAlignment = 'c';
% input.tableBorders = 1;
% % Switch to generate a complete LaTex document or just a table:
% input.makeCompleteLatexDocument = 1;
% % Now call the function to generate LaTex code:
% latex = latexTable(input);
    
writetable(T,['statistics/systems/perfan_',sysName,'_',underlying{1},'_',num2str(lengthData),'M',num2str(timeStep),'.csv'],'WriteRowNames',true);

end

