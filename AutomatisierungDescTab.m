clear
clc
close all
%% setup
setup(); %adds folders to path
underlying = {'EURUSD'}; %cell array
lengthData = 24; %months of data
tVec = 240; %time steps for compression [min]
percentage = 0.4; %percentage out of sample

for jj = 1:length(underlying)
    %% generate dataset structure and store in dat folder
    generateDataSet( underlying{jj}, lengthData, tVec );

    %% write data to csv file
    if size(tVec,2) == 1
        string1 = num2str(tVec');
    else
        string1 = num2str(tVec);
    end
    string1 = string1(~isspace(string1));
    load(['./dat/',underlying{jj},num2str(lengthData),'M',string1,'.mat'])
    eval(['data = ',underlying{jj},'_t1;']);
    descriptiveTable( data, underlying{jj}, percentage )
    
    %Plot Verlauf
    string1 = string1(~isspace(string1));
    plotverlauf( data, underlying{jj}, percentage )
    print(['./plots/verlauf/',underlying{jj},num2str(lengthData),'M_',num2str(tVec)],'-deps')%save plot to folder
    print(['./plots/verlauf/',underlying{jj},num2str(lengthData),'M_',num2str(tVec)],'-dpng')%save plot to folder
    

end
%%

