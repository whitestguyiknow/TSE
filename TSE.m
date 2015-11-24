%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            TRADER SYSTEM ENGINE
%                    
% Authors:          Daniel Waelchli, Mike Schwitalla
% Date:             June 2015
% Version:          1.01
%
% Description:      main engine, function collection in ./func/
%                   data in ./dat/
%                   
%                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear all;
setup();


EURUSD = loadData('EURUSD_SHORTER.csv');
EURUSD_DStmp = preprocessTable(EURUSD);
EURUSD_DS = tcompressMat(EURUSD_DStmp,1,'bid');

usdkurs = ones(length(EURUSD_DS.time),1);
commission = 100;
exampleTrades = getExampleTrades(10,EURUSD_DS.time);
tradingTable = buildTraidingTable(EURUSD_DS.time,EURUSD_DS.bid_close,EURUSD_DS.ask_close,...
    usdkurs,commission,exampleTrades(:,1),exampleTrades(:,2));

    


