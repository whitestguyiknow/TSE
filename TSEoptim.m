%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            First Optimization
%
% Authors:          Daniel Waelchli, Mike Schwitalla
% Date:             January 2016
% Version:          2.00
%
% Description:      main engine,
%                   function collection in ./func/
%                   indicator functions in ./indicators/
%                   optimizer in ./DE/
%                   objective functions in ./obj/
%                   data in ./dat/
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% setup
setup();

% tasks
load = false;
opt = true;

tInit = 100;

if(~load)
% load & process data
EURUSD_raw = loadData('EURUSD_tick.csv');
EURUSD_pre = preprocessTable(EURUSD_raw);
EURUSD_t1 = tcompressMat(EURUSD_pre,15,'bid','ask');
EURUSD_t2 = tcompressMat(EURUSD_pre,60,'bid','ask');

% function handles to precomputed indicators
fBuyRSI = @(DS,i,t) BuyRSI(DS,i,t);
fSellRSI = @(DS,i,t) SellRSI(DS,i,t);
fSdev = @(DS,i,t) sdev(DS,i,t);

% append indicator values
EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'buyRSI_14',fBuyRSI,14);
EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'buyRSI_30',fBuyRSI,30);
EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'sellRSI_14',fSellRSI,14);
EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'sellRSI_30',fSellRSI,30);
EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'sdev',fSdev,50);

EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'buyRSI_14',fBuyRSI,14);
EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'buyRSI_30',fBuyRSI,30);
EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'sellRSI_14',fSellRSI,14);
EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'sellRSI_30',fSellRSI,30);
EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'sdev',fSdev,50);

% save dataset
export(EURUSD_t1,'file','./dat/EURUSD_t1.dat')
export(EURUSD_t2,'file','./dat/EURUSD_t2.dat')
end

% optim parameter
nPopoulation = 10;
maxIter = 25;
CR = 0.5;
F = 1.5;
seed = 8392;
optimStruct = generateOptimStruct(nPopoulation,maxIter,CR,F,seed);

% optimization
if(opt)
    % objective function -sharpe, minimize neg sharpe -> maximiye sharp
    f = @(x) -optim(EURUSD_pre,EURUSD_t1,EURUSD_t2,x); %x: deltaRSI
    [obj,par] = DEoptim(f,optimStruct,[0.1,0.5],'firstRSIoptim.csv');
end


%oben Plot Equity line in of sample vs out of sample and print optimised in of
%sample and print out of sample sharpe ratio


%mitte Kernel density estimate of insample and out of sample return
%distribution
%unten gross Trading hours dependency boxplots hourly returns 1:24 hours


    
