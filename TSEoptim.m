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
%                   plot functions in ./plotfunc/
%                   saved plots in ./plot/
%                   data in ./dat/
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% setup
setup();
dbstop if error

tInit = 100;

% partitioning variable
insamplePCT = 0.7;

% try load
try
    clear EURUSD
    EURUSD = load('./dat/EURUSD.mat');
    EURUSD_pre = EURUSD.EURUSD_pre;
    EURUSD_t1 = EURUSD.EURUSD_t1;
    EURUSD_t2 = EURUSD.EURUSD_t2;
catch   
    % load & process data
    EURUSD_pre = loadDataCsv('EURUSD_tick.csv');
    EURUSD_t1 = compress(EURUSD_pre,15,'bid','ask');
    EURUSD_t2 = compress(EURUSD_pre,60,'bid','ask');
    
    % function handles to precomputed indicators
    fBuyRSI = @(DS,i,t) BuyRSI(DS,i,t);
    fSellRSI = @(DS,i,t) SellRSI(DS,i,t);
    fSdev = @(DS,i,t) sdev(DS,i,t);
    
    % append indicator values
    %EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'buyRSI_14',fBuyRSI,14);
    %EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'buyRSI_30',fBuyRSI,30);
    %EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'sellRSI_14',fSellRSI,14);
    %EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'sellRSI_30',fSellRSI,30);
    EURUSD_t1 = appendIndicator(EURUSD_t1,tInit,'sdev',fSdev,50);
    
    %EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'buyRSI_14',fBuyRSI,14);
    %EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'buyRSI_30',fBuyRSI,30);
    %EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'sellRSI_14',fSellRSI,14);
    %EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'sellRSI_30',fSellRSI,30);
    EURUSD_t2 = appendIndicator(EURUSD_t2,tInit,'sdev',fSdev,50);
    
    % save dataset
    save './dat/EURUSD.mat' EURUSD_pre EURUSD_t1 EURUSD_t2 
end

% pick isamples
% & osamples

% optim parameter
nPopoulation = 30;
maxIter = 100;
CR = 0.7;
F = 1.5;
N_cpu = 3;
seed = 8392;
optimStruct = generateOptimStruct(nPopoulation,maxIter,CR,F,seed,N_cpu);

% partitioning
lp = length(EURUSD_pre); l1 = length(EURUSD_t1); l2 = length(EURUSD_t2);
EURUSD_pre_is = EURUSD_pre(1:ceil(lp*insamplePCT),:);
EURUSD_t1_is = EURUSD_t1(1:ceil(l1*insamplePCT),:);
EURUSD_t2_is = EURUSD_t2(1:ceil(l2*insamplePCT),:);
EURUSD_pre_oos = EURUSD_pre(floor(lp*insamplePCT):end,:);
EURUSD_t1_oos = EURUSD_t1(floor(l1*insamplePCT):end,:);
EURUSD_t2_oos = EURUSD_t2(floor(l2*insamplePCT):end,:);

% optimization
% objective function -sharpe, minimize neg sharpe -> maximize sharp
f = @(x) -optim(EURUSD_pre,EURUSD_t1,EURUSD_t2,x(1),x(2),x(3));
[obj,par] = DEoptim(f,optimStruct,[3,40],[0.1,15],[0.1,15],'2ndRSIoptim.csv');

