%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title:            TRADER SYSTEM ENGINE
%                    
% Authors:          Daniel Waelchli, Mike Schwitalla
% Date:             June 2015
% Version:          1.0
%
% Description:      main engine, function collection in ./func/
%                   data in ./dat/
%                   
%                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
setup();

EURUSD = loadData('EURUSD_SHORT.csv');
EURUSD_DS = preprocessTable(EURUSD);
EURUSD_DS = tcompressMat(EURUSD_DS,1,'ask','spread');

    


