%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            Optimization
%
% Authors:          Daniel Waelchli, Mike Schwitalla
% Date:             January 2016
% Version:          2.00
%
% Description:      main engine for Bug Testing with small amount of data,
%                   function collection in ./func/
%                   indicator functions in ./indicators/
%                   optimizer in ./DE/
%                   objective functions in ./obj/
%                   plot functions in ./plotfunc/
%                   saved plots in ./plot/
%                   data in ./dat/
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
close all

%% Initializing
% setup
setup();

% system parameter
sys_par = getSysPar();

% optim parameter
optimStruct = getOptimPar_test(); %only for testing
% optimStruct = getOptimPar();
      
%% Data processing%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
jj = 1; %select underlying
%put together sting of time steps
if size(sys_par.tVec,2) == 1
    stringTimes = num2str(sys_par.tVec');
else
    stringTimes = num2str(sys_par.tVec);
end
stringTimes = stringTimes(~isspace(stringTimes));
stringConfig = [sys_par.sysName,'_',sys_par.underlying{jj},'_',num2str(sys_par.lengthData),'M',stringTimes];
try
    %load file with compressed tick data
    load(['./dat/',sys_par.underlying{jj},num2str(sys_par.lengthData),'M',stringTimes,'.mat']);
    disp('existing compressed tick data loaded from folder')
catch
    disp('compressed tick data is generated')
    %generate compressed tick data
    generateDataSet(sys_par,jj)
    load(['./dat/',sys_par.underlying{jj},num2str(sys_par.lengthData),'M',stringTimes,'.mat']);
end

%assing data to standard variables
eval(['underlying_pre = ',sys_par.underlying{jj},'_pre;'])
for ii = 1:length(sys_par.tVec)
    eval(['underlying_t',num2str(ii),' = ',sys_par.underlying{jj},'_t',num2str(ii),';'])
end

% function handles to precomputed, global indicators
  fSdev = @(DS,i,t) sdev(DS,i,t);% Standarddeviation of underlying of last t datapoints
  
% append indicator values
  underlying_t1 = appendIndicator(underlying_t1,sys_par,'sdev',fSdev,50);
  underlying_t2 = appendIndicator(underlying_t2,sys_par,'sdev',fSdev,50);
  
% partitioning
% insample
underlying_pre_is =     partition('in',underlying_pre,sys_par);%AV:ACHtung in Sys_par wird die Partition in and out of sample festgelegt
underlying_t1_is =      partition('in',underlying_t1,sys_par);
underlying_t2_is =      partition('in',underlying_t2,sys_par);
% outsample
underlying_pre_oos =    partition('out',underlying_pre,sys_par);
underlying_t1_oos =     partition('out',underlying_t1,sys_par);
underlying_t2_oos =     partition('out',underlying_t2,sys_par);

%% Setting entry and exit rules & optimization%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist(['./dat/optresults/bestever_',stringConfig,'.mat'],'file') %check there already exists solution
    dlgTitle    = 'Optimization';
    dlgQuestion = 'There already exists a solution. Do you want to optimize again?';
    choice = questdlg(dlgQuestion,dlgTitle,'Yes','No', 'Yes');
    if strcmp(choice,'Yes')
        optimize_on = 1;
    else
        optimize_on = 0;
    end
else
    optimize_on = 1;
end
    
if optimize_on
    %(entry and exit rules defind in optimintraday or optimdaily)
    xinit = [5,1,1]'; %Initial Startpoint for CMA
    addpath('./optimize/');
    %Intraday Optimisation. (For Daily Optimisation use optimdaily instead of
    %optimintraday
    timeoptimstart=clock;

    [obj,par,counteval,stopflag,out,bestever] = ...
        CMAoptim('optimintraday',xinit,[],optimStruct,underlying_pre_is,underlying_t1_is,underlying_t2_is,sys_par);

    timeoptimend=clock;
    evaltime= roundn(floor(etime(timeoptimend,timeoptimstart))/60,-1);
    N_cpu=numlabs;
    fprintf('Time used for optimisation: %.1f min with %.0f CPUs\n', evaltime,N_cpu);
    %save bestever
    save(['./dat/optresults/bestever_',stringConfig,'.mat'],'bestever')
end
%% out and in of sample run of sample run
%load bestever from optimization
load(['./dat/optresults/bestever_',stringConfig,'.mat'])

% Best Tradingparameter creation
LB = 10;
fBuyEntry = @(DS1,i,DS2,k) entryBuyStoch(DS1,i,DS2,k,LB,bestever.x(1));
fSellEntry = @(DS1,i,DS2,k) entrySellStoch(DS1,i,DS2,k,LB,bestever.x(1));
fBuyExit = @(DS1,i,DS2,k) exitBuyTrailingSDEV(DS1,i,DS2,k,bestever.x(2),bestever.x(3));
fSellExit = @(DS1,i,DS2,k) exitSellTrailingSDEV(DS1,i,DS2,k,bestever.x(2),bestever.x(3));

%insample run
usdkursis = ones(length(underlying_pre_is.time),1);
[isTime, isAction] = buildActionMatrix(underlying_t1_is,underlying_t2_is,fBuyEntry,fBuyExit,fSellEntry,fSellExit, sys_par);
isTradingTable = buildTradingTable(underlying_pre_is,isTime,isAction*100000,usdkursis,sys_par);
isDailyTT = buildDailyTradingTable(isTradingTable, sys_par);

%out of sample run
usdkursoos = ones(length(underlying_pre_oos.time),1);
[oosTime, oosAction] = buildActionMatrix(underlying_t1_oos,underlying_t2_oos,fBuyEntry,fBuyExit,fSellEntry,fSellExit, sys_par);
oosTradingTable = buildTradingTable(underlying_pre_oos,oosTime,oosAction*100000,usdkursoos,sys_par);
oosDailyTT = buildDailyTradingTable(oosTradingTable, sys_par);
%save
save( ['./dat/optresults/Trtables_',stringConfig,'.mat'], 'isTradingTable', 'isDailyTT', 'oosTradingTable', 'oosDailyTT');

%% plotting
ii = 1; %select time step of tVec
%Loading results test
load(['./dat/optresults/Trtables_',stringConfig,'.mat']);

%%Performance Analytics
plot_cumret_dens_invsout(isTradingTable.Return,oosTradingTable.Return, ...
    sys_par.underlying{jj}, sys_par.sysName, sys_par.lengthData, sys_par.tVec(ii))

%Boxplot

tBox = 60; %time step of boxplot
if sys_par.tVec(ii) > 60
    tBox = sys_par.tVec(ii);
end;
boxInVsOut( isTradingTable, oosTradingTable,tBox, ...
    sys_par.underlying{jj}, sys_par.sysName, sys_par.lengthData, sys_par.tVec(ii) );

%%
%A:Performance Analytics Table (saved under: /statistics/systems/perfan_'SystemName'_'Underlying'_'Zeitintervall'.csv)
perfAnTable(isTradingTable, isDailyTT,...
    oosTradingTable, oosDailyTT,...
    underlying_pre, sys_par.sysName, sys_par.underlying, sys_par.tVec(ii),...
    sys_par.lengthData)

