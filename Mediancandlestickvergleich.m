%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            Comparison of normal OHLC and modified OHLC-Median
% Date:             January 2016
% Version:          2.00
%
%Output: 	A plot with normal Candlesticks and modified with median
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
setup(); %adds folders to path
%% system parameter
sys_par.underlying = {'EURNOK'}; %underlying (string)
sys_par.lengthData = 6; %length of tick data (months)
sys_par.tVec = [60;120]; %time steps tick data is compressed to (min)
sys_par.sysName = 'xy';
sys_par.echo = false;

%% Data processing
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
    generateDataSet(sys_par,1)
    load(['./dat/',sys_par.underlying{jj},num2str(sys_par.lengthData),'M',stringTimes,'.mat']);
end

%assing data to standard variables
eval(['underlying_pre = ',sys_par.underlying{jj},'_pre;'])
for ii = 1:length(sys_par.tVec)
    eval(['underlying_t',num2str(ii),' = ',sys_par.underlying{jj},'_t',num2str(ii),';'])
end

%% plot
startpoint=1000;
number= 240;
figure
indexTimeStep = 1; %defines which timeframe from tVec is used
%%%%%%%%%%%%%%%%%%% CANDLESTICK NORMAL + MEDIAN********
%%%%%%%Normal Candlestick Plot
subplot(2,1,1);
% datacndl(underlying_t2, startpoint, number)
datacndlmed(eval(['underlying_t',num2str(indexTimeStep)]), startpoint, number, 0) %last argument decides if median is plotted
t=title(['Normale ',num2str(sys_par.tVec(indexTimeStep)),' min Candlestick (OHLC Data)']);
set(t,'FontSize', 12);
xlabel('Date [DD-MM-YY]')
ylabel(sys_par.underlying)
hold off;

%%%%Candle Stick with MEDIAN Whoop Whooop! Idea using as Turningpoint Indication.... 
subplot(2,1,2);
datacndlmed(eval(['underlying_t',num2str(indexTimeStep)]), startpoint, number, 1)
t=title(['Modifizierte ',num2str(sys_par.tVec(indexTimeStep)),' min Candlesticks mit Tickdaten-Median (OHLC+Median)']);
set(t,'FontSize', 12);
xlabel('Date [DD-MM-YY]')
ylabel(sys_par.underlying)
hold off;

%% save plots
saveas(gcf,'./plots/ExampleCandlestickwithmedian','epsc') %EPS for latex
saveas(gcf,'./plots/ExampleCandlestickwithmedian','png') %PNG normal
close;

