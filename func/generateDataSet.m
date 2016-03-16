function [] = generateDataSet( underlying, lengthData, tVec )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% check if csv file exists
if exist([underlying,'_tick_',num2str(lengthData),'M.csv'],'file') ~= 2
    disp(['no data available for ',underlying,', length = ',num2str(lengthData),' months'])
end

%% generate variables
var = genvarname([underlying,'_pre']);
data = loadDataCsv([underlying,'_tick_',num2str(lengthData),'M.csv']);
eval([var,' = data;']) %%Ladet die Daten
for ii = 1:length(tVec)
    var = genvarname([underlying,'_t',num2str(ii)]);
    eval([var,' = compress(',underlying,'_pre,tVec(',num2str(ii),'),''bid'',''ask'');']);
end
%%
if size(tVec,2) == 1
    string1 = num2str(tVec');
else
    string1 = num2str(tVec);
end
string1 = string1(~isspace(string1));
%%
save(['./dat/',underlying,num2str(lengthData),'M',string1,'.mat'],[underlying,'*'])
end

