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
clear all;
setup();

EURUSD = loadData('EURUSD_SHORTER.csv');
EURUSD_DStmp = preprocessTable(EURUSD);
EURUSD_DS = tcompressMat(EURUSD_DStmp,1,'bid');

    


