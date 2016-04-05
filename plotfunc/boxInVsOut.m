function [ ] = boxInVsOut( inOfSampleTable, outOfSampleTable,...
    tBox, underlying, System, Zeitintervall )
%boxInVsOut( inOfSampleTable, outOfSampleTable, tBox, underlying, System, Zeitintervall )
%   Creates boxplots
%% plot
scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4)/2 1920*0.75 1080*0.75])
clf
for jj = 1:4
    if jj == 1 || jj == 2
        timeString = 'EntryTime';
    else
        timeString = 'ExitTime';
    end
    if jj == 1 || jj == 3
        dataTable = inOfSampleTable;
        dataString = 'in-of sample';
    else
        dataTable = outOfSampleTable;
        dataString = 'out-of sample';
    end
    %generate bin matrix
    [binMatrix,timeVecCenter,medRet] = setUpBinMatrix(dataTable, tBox, timeString);
    %plot median
	subplot(2,2,jj)
    plot([0,24],medRet*ones(1,2),'--k')
    %boxplot
    hold on
    boxplot(binMatrix,'labels',num2cell(timeVecCenter));
    hold off
    %labels
    ax = gca;
    ax.XTickLabelRotation = 45;
    ax.FontSize = 6;
    ylabel('Return [%]')
    xlabel('Zeit [h]')
    title([timeString,' ',dataString])
    grid minor
    legend('Median','Location','SouthEast')
    legend('boxoff')
    
end
titleAll = mtit(['Boxplot',', System: ',System,', ',underlying,', Zeitintervall: ',Zeitintervall]);
set(titleAll.th,'Position',titleAll.th.Position+[0;0.04;0]')

%% save figures
print(['./plots/boxplots/','boxplot_',System,'_',underlying,'_',Zeitintervall],'-deps')%save plot to folder
print(['./plots/boxplots/','boxplot_',System,'_',underlying,'_',Zeitintervall],'-dpng')%save plot to folder
close
end

function [binMatrix,timeVecCenter,medRet] = setUpBinMatrix(dataTable, tBox, time)
% number of bins
nOfBins = floor(24*60/tBox);
timeVecBorders = 0:tBox/60:nOfBins*tBox/60;
timeVecCenter = linspace(tBox/60/2,24-tBox/60/2,nOfBins);

% set up bin matrix
timeDataTable = eval(['dataTable.',time]);
binMatrix = nan(size(dataTable,1),nOfBins);
for ii = 1:size(dataTable,1)%iterate trough data
    currTime = timeDataTable(ii,4)+timeDataTable(ii,5)/60;
    indexBin = find(currTime >= timeVecBorders,1,'last');
    binMatrix(ii,indexBin) = dataTable.Return(ii);
end

%average return over all trades
medRet = median(dataTable.Return);
end