%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            Automation of Intraday Patterns Plot
% Date:             January 2016
% Version:          2.00
%
%Output: 	A plot with Spread as pips and volatility as absolute return
%		
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
close all
%% setup
setup(); %adds folders to path
sys_par = getSysPar();
%underlying = {'USDJPY'; 'EURUSD'; 'EURNOK'; 'EURSEK'}
%underlying = {'EURUSD';'USDJPY';'AUDUSD';'GBPUSD';'NZDUSD';'USDCAD';'USDCHF'}; %cell array Majors
%underlying = {'AUDCAD';'AUDJPY';'AUDNZD';'EURAUD';'EURGBP';'EURJPY';'EURCAD';'EURNOK';'EURSEK';'EURNZD';'GBPCHF';'GBPJPY';'CADJPY';'GBPAUD';'GBPCAD';'GBPNZD';'USDCNH';'NZDCAD';'NZDJPY'}; %Minors
%underlying = {'USDZAR';'USDTRY';'USDMXN';'EURPLN';}; %Exotics
%underlying = {'BRENTCMDUSD';'XAGUSD';'XAUUSD'}%;'CUCMDUSD';'PDCMDUSD';'PTCMDUSD'}; %COMMODITIES
%underlying = {'USA500IDXUSD';'USATECHIDXUSD';'CHEIDXCHF';'DEUIDXEUR'}; %INDICES
underlying = {'EURUSD';'USDJPY';'AUDUSD';'GBPUSD';'NZDUSD';'USDCAD';'USDCHF';'AUDCAD';'AUDJPY';'AUDNZD';'EURAUD';'EURGBP';'EURJPY';'EURCAD';'EURNOK';'EURSEK';'EURNZD';'GBPCHF';'GBPJPY';'CADJPY';'GBPAUD';'GBPCAD';'GBPNZD';'USDCNH';'NZDCAD';'NZDJPY';'USDZAR';'USDTRY';'USDMXN';'EURPLN';'BRENTCMDUSD';'XAGUSD';'XAUUSD';'USA500IDXUSD';'USATECHIDXUSD';'CHEIDXCHF';'DEUIDXEUR'};
lengthData = 6; %months of data
tVec = [15;480]; %time steps for compression [min]

for jj = 1:length(underlying)
    

    %% plot
    if size(tVec,2) == 1
        string1 = num2str(tVec');
    else
        string1 = num2str(tVec);
    end
    string1 = string1(~isspace(string1));
    
    try
        load(['./dat/',underlying{jj},num2str(lengthData),'M',string1,'.mat'])
    catch
        %generate dataset structure and store in dat folder
        generateDataSet( underlying{jj}, lengthData, tVec );
        load(['./dat/',underlying{jj},num2str(lengthData),'M',string1,'.mat'])
    end
    
    for ii = 1:length(tVec)
        eval(['data = ',underlying{jj},'_t',num2str(ii),';']);
        spreadspan( data, underlying{jj} )
%         eval(['spreadspan(',underlying{jj},'_t',num2str(ii),',underlying{',num2str(jj),'});']) %call plot function
        
        print(['./plots/spread/',underlying{jj},num2str(lengthData),'M_',num2str(tVec(ii))],'-deps')%save plot to folder
        print(['./plots/spread/',underlying{jj},num2str(lengthData),'M_',num2str(tVec(ii))],'-dpng')%save plot to folder
        udx = {[underlying{jj} num2str(tVec(ii)) ' done']};
        disp(udx)
        close all
    end

end
    clear all