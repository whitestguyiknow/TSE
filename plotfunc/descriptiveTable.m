function [ ] = descriptiveTable( data, underlying, percentage )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%%
Ntot = length(data.time(:,1));
if percentage <= 0
    ind_out = [];
    ind_in = 1:Ntot;
elseif percentage>0 && percentage<1
    indexChange = floor((1-percentage)*Ntot);
    ind_out = indexChange+1:Ntot;
    ind_in = 1:indexChange;
else %percentage >= 0
    ind_out = 1:Ntot;
    ind_in = [];
end

dt = mode(diff(data.time(:,4)*60+data.time(:,5)));

    
%%
returnData =    ((data.ask_close-data.ask_open)./data.ask_open);
verlaufData =   data.ask_open;

daten = {   [datestr(data.time(ind_in(1),:),'yyyy.mm.dd HH:MM'),' - ',datestr(data.time(ind_in(end),:),'yyyy.mm.dd HH:MM')];...
            [datestr(data.time(ind_out(1),:),'yyyy.mm.dd HH:MM'),' - ',datestr(data.time(ind_out(end),:),'yyyy.mm.dd HH:MM')]};
        


N =             [length(ind_in);length(ind_out)];
meanReturn =    [mean(returnData(ind_in));mean(returnData(ind_out))];
stdDev =        [std(verlaufData(ind_in));std(verlaufData(ind_out))];
stdErrMean =    [stdDev(1)/sqrt(length(ind_in));stdDev(2)/sqrt(length(ind_out))];
tRatio =        [meanReturn(1)/stdErrMean(1);meanReturn(2)/stdErrMean(2)];
skwnss =        [skewness(returnData(ind_in));skewness(returnData(ind_out))];
krtsis =        [kurtosis(returnData(ind_in));kurtosis(returnData(ind_out))];
minVal =        [min(returnData(ind_in));min(returnData(ind_out))];
maxVal =        [max(returnData(ind_in));max(returnData(ind_out))];
medianVal =     [median(returnData(ind_in));median(returnData(ind_out))];


RowNames = {underlying;'N';'Mean Return';'Std. Deviation';'Standard Fehler';'t-ratio';'Skewness';'Kurtosis';'Min';'Max';'Median'}';
InSample =      (daten{1};N(1);meanReturn(1);stdDev(1);stdErrMean(1);tRatio(1);skwnss(1);krtsis(1);minVal(1);maxVal(1);medianVal(1))';
OutOfSample =   (daten{2};N(2);meanReturn(2);stdDev(2);stdErrMean(2);tRatio(2);skwnss(2);krtsis(2);minVal(2);maxVal(2);medianVal(2))';
T = table(InSample,OutOfSample,'RowNames',RowNames);
T.Properties.DimensionNames{1} = 'Vars';


% % Print Latex table
% input.data = T;
% input.tableColumnAlignment = 'c';
% input.tableBorders = 1;
% % Switch to generate a complete LaTex document or just a table:
% input.makeCompleteLatexDocument = 1;
% % Now call the function to generate LaTex code:
% latex = latexTable(input);
    
writetable(T,['statistics/data/descstat_',underlying,'.csv'],'WriteRowNames',true);


%%
end

