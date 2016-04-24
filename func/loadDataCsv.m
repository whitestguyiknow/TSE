function [DS] = loadDataCsv(datCsv,sys_par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function: load data & preprocessing
%           return dataset           
% created by Daniel, December 2015
%
% Last update: 2016 Jan 28, by Daniel
%   2016-01-28: (Daniel)
%       1. restructuring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
if sys_par.echo
    disp('reading table from csv file..');
    tic;
end
%% read data from csv table
% variant 1
% disp('readtable: ')
% tic
dataTable = readtable(datCsv,'ReadVariableNames',false,'ReadRowNames',false,...
'TreatAsEmpty',{'NA'});
% toc

% variant 2
% quote = '"';
% sep = ',';
% escape = ' ';
% disp('swallow_csv: ')
% tic
% [numbers, text] = swallow_csv(datCsv, quote, sep, escape);
% dataTableFast = table(text(:,1),numbers(:,2),numbers(:,3),numbers(:,4),numbers(:,5));
% toc

% variant 3
% disp('manual:')
% tic
% fid = fopen(datCsv, 'rt');
% headerline = fgetl(fid);
% headerfields = regexp(headerline, ',', 'split');
% numcol = length(headerfields);
% numrow = count_remaining_lines(fid);
% frewind(fid);
% data = cell(numrow, numcol);
% data_temp = cell(1,numcol);
% ii = 1;
% while true
% %     disp(num2str(ii))
%     if ii > numrow; break; end;
%     headerline = fgetl(fid);
%     data_temp = regexp(headerline, ',', 'split');
%     for jj = 1:numcol
%         data{ii,jj} = data_temp{jj};
%     end
%     ii = ii + 1;
% end
% toc


%%
cnames = {'time','bid','ask','size_bid','size_ask'};
dataTable.Properties.VariableNames = cnames;
TF = ismissing(dataTable,{'' '.' 'NA' NaN});
dataTable = dataTable(~any(TF,2),:);

M = zeros(size(dataTable) - [0 1]);
M(:,1) = datenum(dataTable.time,'yyyy.mm.dd HH:MM:SS.FFF');
M(:,2:3) = dataTable{:,2:3};
M(:,4) = dataTable.ask-dataTable.bid;

DS = dataset({M 'time','bid','ask','spread'});
DS((DS.spread<0),:) = []; %remove negative spreads;
DS.time = datevec(DS.time);

if sys_par.echo
    disp('DONE!');
    toc;
end
end
function numlines = count_remaining_lines(fid)
   numlines = 1;
   while true
     if ~ischar(fgets(fid)); break; end    %end of file
     numlines = numlines + 1;
%      disp(num2str(numlines))
   end
 end