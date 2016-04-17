%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            Automation of Descriptiv Data Creation
% Date:             January 2016
% Version:          2.00
%
%Output: 	CSV table with descriptive statisticsand generates
%		a price and return plot for each sys_par.underlying
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
close all
%% setup
setup(); %adds folders to path
sys_par = getSysPar();

%sys_par.underlying = {'EURUSD';'USDJPY';'AUDUSD';'GBPUSD';'NZDUSD';'USDCAD';'USDCHF'}; %cell array Majors
%sys_par.underlying = {'AUDCAD';'AUDJPY';'AUDNZD';'EURAUD';'EURGBP';'EURJPY';'EURCAD';'EURNOK';'EURSEK';'EURNZD';'GBPCHF';'GBPJPY';'CADJPY';'GBPAUD';'GBPCAD';'GBPNZD';'USDCNH';'NZDCAD';'NZDJPY'}; %Minors
%sys_par.underlying = {'USDZAR';'USDTRY';'USDMXN';'EURPLN';}; %Exotics
%sys_par.underlying = {'BRENTCMDUSD';'XAGUSD';'XAUUSD'}%;'CUCMDUSD';'PDCMDUSD';'PTCMDUSD'}; %COMMODITIES
%sys_par.underlying = {'USA500IDXUSD';'USATECHIDXUSD';'CHEIDXCHF';'DEUIDXEUR'}; %INDICES
%sys_par.underlying = {'EURUSD';'USDJPY';'AUDUSD';'GBPUSD';'NZDUSD';'USDCAD';'USDCHF';'AUDCAD';'AUDJPY';'AUDNZD';'EURAUD';'EURGBP';'EURJPY';'EURCAD';'EURNOK';'EURSEK';'EURNZD';'GBPCHF';'GBPJPY';'CADJPY';'GBPAUD';'GBPCAD';'GBPNZD';'USDCNH';'NZDCAD';'NZDJPY';'USDZAR';'USDTRY';'USDMXN';'EURPLN';'BRENTCMDUSD';'XAGUSD';'XAUUSD';'USA500IDXUSD';'USATECHIDXUSD';'CHEIDXCHF';'DEUIDXEUR'};

percentage= 1-sys_par.insamplePCT;
for jj = 1:length(sys_par.underlying)
    

    %% write data to csv file
    if size(sys_par.tVec,2) == 1
        string1 = num2str(sys_par.tVec');
    else
        string1 = num2str(sys_par.tVec);
    end
    string1 = string1(~isspace(string1));
    %% print CSV
    try
        load(['./dat/',sys_par.underlying{jj},num2str(sys_par.lengthData),'M',string1,'.mat'])
    catch
        %generate dataset structure and store in dat folder
        generateDataSet( sys_par,jj);
        load(['./dat/',sys_par.underlying{jj},num2str(sys_par.lengthData),'M',string1,'.mat'])
    end
    
    
    eval(['data = ',sys_par.underlying{jj},'_t1;']);
    %descriptiveTable( data, sys_par.underlying{jj}, percentage );

    %% Plot Verlauf
    string1 = string1(~isspace(string1));
    plotverlauf( data, sys_par.underlying{jj}, percentage )
    print(['./plots/verlauf/',sys_par.underlying{jj},num2str(sys_par.lengthData),'M_',num2str(sys_par.tVec(1))],'-depsc')%save plot to folder
    print(['./plots/verlauf/',sys_par.underlying{jj},num2str(sys_par.lengthData),'M_',num2str(sys_par.tVec(1))],'-dpng')%save plot to folder
    udx = {[sys_par.underlying{jj} num2str(sys_par.tVec(1)) ' done']};
    disp(udx)
    close all

end
%%

