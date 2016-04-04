%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            Automation of Descriptiv Data Creation
% Date:             January 2016
% Version:          2.00
%
%Output: 	CSV table with descriptive statisticsand generates
%		a price and return plot for each underlying
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
close all
%% setup
setup(); %adds folders to path
sys_par = getSysPar();
%underlying = {'EURUSD','USDJPY','EURNOK','EURSEK'};
%underlying = {'EURUSD';'USDJPY';'AUDUSD';'GBPUSD';'NZDUSD';'USDCAD';'USDCHF'}; %cell array Majors
%underlying = {'AUDCAD';'AUDJPY';'AUDNZD';'EURAUD';'EURGBP';'EURJPY';'EURCAD';'EURNOK';'EURSEK';'EURNZD';'GBPCHF';'GBPJPY';'CADJPY';'GBPAUD';'GBPCAD';'GBPNZD';'USDCNH';'NZDCAD';'NZDJPY'}; %Minors
%underlying = {'USDZAR';'USDTRY';'USDMXN';'EURPLN';}; %Exotics
%underlying = {'BRENTCMDUSD';'XAGUSD';'XAUUSD'}%;'CUCMDUSD';'PDCMDUSD';'PTCMDUSD'}; %COMMODITIES
%underlying = {'USA500IDXUSD';'USATECHIDXUSD';'CHEIDXCHF';'DEUIDXEUR'}; %INDICES
underlying = {'EURUSD';'USDJPY';'AUDUSD';'GBPUSD';'NZDUSD';'USDCAD';'USDCHF';'AUDCAD';'AUDJPY';'AUDNZD';'EURAUD';'EURGBP';'EURJPY';'EURCAD';'EURNOK';'EURSEK';'EURNZD';'GBPCHF';'GBPJPY';'CADJPY';'GBPAUD';'GBPCAD';'GBPNZD';'USDCNH';'NZDCAD';'NZDJPY';'USDZAR';'USDTRY';'USDMXN';'EURPLN';'BRENTCMDUSD';'XAGUSD';'XAUUSD';'USA500IDXUSD';'USATECHIDXUSD';'CHEIDXCHF';'DEUIDXEUR'};
lengthData = 24; %months of data
tVec = 240; %time steps for compression [min]
percentage = 0.6; %percentage out of sample

for jj = 1:length(underlying)
    

    %% write data to csv file
    if size(tVec,2) == 1
        string1 = num2str(tVec');
    else
        string1 = num2str(tVec);
    end
    string1 = string1(~isspace(string1));
    %% print CSV
    try
        load(['./dat/',underlying{jj},num2str(lengthData),'M',string1,'.mat'])
    catch
        %generate dataset structure and store in dat folder
        generateDataSet( underlying{jj}, lengthData, tVec );
        load(['./dat/',underlying{jj},num2str(lengthData),'M',string1,'.mat'])
    end
    
    
    eval(['data = ',underlying{jj},'_t1;']);
    descriptiveTable( data, underlying{jj}, percentage );

    
    %% Plot Verlauf
    string1 = string1(~isspace(string1));
    plotverlauf( data, underlying{jj}, percentage )
    print(['./plots/verlauf/',underlying{jj},num2str(lengthData),'M_',num2str(tVec)],'-deps')%save plot to folder
    print(['./plots/verlauf/',underlying{jj},num2str(lengthData),'M_',num2str(tVec)],'-dpng')%save plot to folder
    udx = {[underlying{jj} num2str(tVec) ' done']};
    disp(udx)
    close all

end
%%

