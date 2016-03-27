clear
clc
close all
%% setup
setup(); %adds folders to path
underlying = 'EURUSD';
lengthData = 3; %months of data
tVec = [5;15;30;60]; %time steps for compression [min]

%% generate dataset structure and store in dat folder
generateDataSet( underlying, lengthData, tVec );

%% plot
if size(tVec,2) == 1
    string1 = num2str(tVec');
else
    string1 = num2str(tVec);
end
string1 = string1(~isspace(string1));
load(['./dat/',underlying,num2str(lengthData),'M',string1,'.mat'])
for ii = 1:length(tVec)
    eval(['spreadspan(',underlying,'_t',num2str(ii),',underlying);']) %call plot function
    print(['./spread/',underlying,num2str(lengthData),'M_',num2str(tVec(ii))],'-deps') %save plot to plots folder
end
