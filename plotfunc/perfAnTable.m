function [ ] = perfAnTable( isTradingTable, isDailyTT,...
                            oosTradingTable, oosDailyTT,...
                            underlying_pre,...
                            sysName, underlying, timeStep, lengthData,...
                            bestever)
%perfAnTable()
%   Performance Analytics Table
%% extract needed data
%number of days
nDays = [   daysact( datestr(isTradingTable.EntryTime(1,:)),datestr(isTradingTable.ExitTime(end,:)) );
            daysact( datestr(oosTradingTable.EntryTime(1,:)),datestr(oosTradingTable.ExitTime(end,:)) )];
%cumulative return
crin = nan(size(isTradingTable.Return));
crin(1)= isTradingTable.Return(1);
for i= 2:length(isTradingTable.Return)
    crin(i)=(crin(i-1)+1)*(1+isTradingTable.Return(i))-1;
end
crout = nan(size(oosTradingTable.Return));
crout(1)= oosTradingTable.Return(1);
for i= 2:length(oosTradingTable.Return)
    crout(i)=(crout(i-1)+1)*(1+oosTradingTable.Return(i))-1;
end
cumuRet = [crin(end);crout(end)];
%% data to write in table
daten = {   [datestr(isTradingTable.EntryTime(1,:),' yyyy.mm.dd HH:MM'),' - ',datestr(isTradingTable.ExitTime(end,:),' yyyy.mm.dd HH:MM')];...
            [datestr(oosTradingTable.EntryTime(1,:),' yyyy.mm.dd HH:MM'),' - ',datestr(oosTradingTable.ExitTime(end,:),' yyyy.mm.dd HH:MM')]};

bestParam = {['x = [',num2str(bestever.x'),'], f = ',num2str(bestever.f),', evals = ',num2str(bestever.evals)];[]};

nTrades =   [   size(isTradingTable,1);
                size(oosTradingTable,1)];

avTradesPerDay = nTrades./nDays;

nShort =    [   length(isTradingTable.Position(isTradingTable.Position<0));
                length(oosTradingTable.Position(oosTradingTable.Position<0))];

nLong =     [   length(isTradingTable.Position(isTradingTable.Position>0));
                length(oosTradingTable.Position(oosTradingTable.Position>0))];
 
meanReturnTot =     100*[   mean(isTradingTable.Return);
                            mean(oosTradingTable.Return)];

[~,pValTotIs] =     ttest(isTradingTable.Return);
[~,pValTotOs] =     ttest(oosTradingTable.Return);
                        
pValTot =           [pValTotIs;pValTotOs];

meanReturnLong = 	100*[   mean(isTradingTable.Return(isTradingTable.Position>0));
                            mean(oosTradingTable.Return(oosTradingTable.Position>0))];

[~,pValLongIs] =    ttest(isTradingTable.Return(isTradingTable.Position>0));
[~,pValLongOs] =    ttest(oosTradingTable.Return(oosTradingTable.Position>0));
pValLong =          [pValLongIs;pValLongOs];

meanReturnShort = 	100*[   mean(isTradingTable.Return(isTradingTable.Position<0));
                            mean(oosTradingTable.Return(oosTradingTable.Position<0))];

[~,pValShortIs] =    ttest(isTradingTable.Return(isTradingTable.Position<0));
[~,pValShortOs] =    ttest(oosTradingTable.Return(oosTradingTable.Position<0));
pValShort =         [pValShortIs;pValShortOs];

winRatio =          100*[   size(isTradingTable(isTradingTable.Return>0,:),1);
                            size(oosTradingTable(oosTradingTable.Return>0,:),1)]./nTrades;

maxDuration =       [   max(isTradingTable.Duration);
                        max(oosTradingTable.Duration)]./60;

minDuration =       [   min(isTradingTable.Duration);
                        min(oosTradingTable.Duration)]./60;

medDuration =       [   median(isTradingTable.Duration);
                        median(oosTradingTable.Duration)]./60;

profFactor =        [   sum(isTradingTable.Return(isTradingTable.Return>0,:))/sum(-isTradingTable.Return(isTradingTable.Return<0,:));
                        sum(oosTradingTable.Return(oosTradingTable.Return>0,:))/sum(-oosTradingTable.Return(oosTradingTable.Return<0,:))];

maxDD =             100*[   maxdrawdown(isTradingTable);
                            maxdrawdown(oosTradingTable)];

PUPRat =            [   morereturnobj(isTradingTable);
                        morereturnobj(oosTradingTable)];
                    
kumReturnAnn =      cumuRet./nDays*250;

KellyKrit =     [   mean(isTradingTable.Return)/std(isTradingTable.Return)^2;
                 	mean(oosTradingTable.Return)/std(oosTradingTable.Return)^2];

sharpeAnn =         [nan;nan];

sortinoAnn =        [nan;nan];
                    
%% row names
RowNames = {    [underlying{1},' ', num2str(timeStep),' min'];
                'Best Parameter';
                'Anzahl Trades';
                'Durchschnittle Trades pro Tag';
                'Anzahl Short';
                'Anzahl Long';
                'Mean Return Total [%]';
                'p-Value Total';
                'Mean Retrun Long [%]';
                'p-Value Long';
                'Mean Short [%]';
                'p-ValueShort';
                'Win Ratio';
                'Max Duration [min]';
                'Min Duration [min]';
                'Median Duration [min]';
                'Profit Factor';
                'Max DD [%]';
                'PUP-Ratio';
                'kumulierter Retrun annualisiert';
                'Kelly Kriterium';
                'Sharpe annualisiert';
                'Sortino annualisiert'};
%% write data in columns       
InOfSample =      { daten{1};
                    bestParam{1};
                    nTrades(1);
                    avTradesPerDay(1);
                    nShort(1);
                    nLong(1);
                    meanReturnTot(1);
                    pValTot(1);
                    meanReturnLong(1);
                    pValLong(1);
                    meanReturnShort(1);
                    pValShort(1);
                    winRatio(1);
                    maxDuration(1);
                    minDuration(1);
                    medDuration(1);
                    profFactor(1);
                    maxDD(1);
                    PUPRat(1);
                    kumReturnAnn(1);
                    KellyKrit(1);
                    sharpeAnn(1);
                    sortinoAnn(1)};
                    
OutOfSample =   {   daten{2};
                    bestParam{2};
                    nTrades(2);
                    avTradesPerDay(2);
                    nShort(2);
                    nLong(2);
                    meanReturnTot(2);
                    pValTot(2);
                    meanReturnLong(2);
                    pValLong(2);
                    meanReturnShort(2);
                    pValShort(2);
                    winRatio(2);
                    maxDuration(2);
                    minDuration(2);
                    medDuration(2);
                    profFactor(2);
                    maxDD(2);
                    PUPRat(2);
                    kumReturnAnn(2);
                    KellyKrit(2);
                    sharpeAnn(2);
                    sortinoAnn(2)};
%% set up table
T = table(InOfSample,OutOfSample,'RowNames',RowNames);
T.Properties.DimensionNames{1} = 'Vars';

%% write to table
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

