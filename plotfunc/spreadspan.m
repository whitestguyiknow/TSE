function [] = spreadspan( data, underlying )
%spreadspan(data, underlying) Plots Spread and Spannweite for selected day
%   Inputs:
%       data        dataset
%       underlying  string for plot labelling
%   Outputs:
%       ouput       0 or 1

%% sort dataset after date and time
dataSorted = sortrows(data,'time');

%% extract data
timeVec =           dataSorted.time(:,4)+dataSorted.time(:,5)./60; %neglect seconds
timeVecPlot =       linspace(0,24,24*60+1);
dtData = mode(diff(timeVec)); %time step size of data

spreadVec =         dataSorted.MED_ask-dataSorted.MED_bid;
spannweiteVec =     abs((dataSorted.bid_close - dataSorted.bid_open)./dataSorted.bid_open);%%%%%%%

%% polyfit
% %% polyfit to spread data points
% n = 4;
% [pSpread,sSpread,mueSpread] = polyfit(timeVec,closeSpreadVec,n);
% [y_fitSpread,deltaSpread] = polyval(pSpread,timeVecPlot,sSpread,mueSpread);
% 
% %% polyfit to Absolute Return
% [pSpann,sSpann] = polyfit(timeVec,spannweiteVec,n);
% [y_fitSpann,deltaSpann] = polyval(pSpann,timeVecPlot,sSpann);


%% splinefit
n = 4; % (n=4 -> cubic)
if dtData <= 1
    dt = 2; %[h]
else
    dt = 2*dtData;
end
breaks = linspace(0,24,24/dt+1);
ppSpread =      splinefit(timeVec,spreadVec,breaks,n);
ppSpannweite =  splinefit(timeVec,spannweiteVec,breaks,n);

%% plot

%%%%%%%%% plot options %%%%%%%%%%%%%%%%%%%%
markersize = 4; %size of dots
transparency = 0.3; %transparency of dots
linewidth = 2; %linewidth of spline
yAxMult = 5; %constant for y axis scaling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plotting
figure
ax1 = subplot(2,1,1);
s1 = scatter(timeVec,spreadVec,markersize,'filled','b'); %data points
alpha(s1,transparency)
hold on
plot(timeVecPlot,ppval(ppSpread,timeVecPlot),'r','LineWidth',linewidth)
plot(breaks,ppval(ppSpread,breaks),'r*')
% plot(timeVecPlot, y_fitSpread,'k')
% plot(timeVecPlot, y_fitSpread+deltaSpread,'r')
% plot(timeVecPlot, y_fitSpread-deltaSpread,'r')
hold off
legend('data points','spline fit','poly breaks','Location','NorthWest')
ylabel('Spread')
title([underlying,', time step: ',num2str(dtData*60),'min, poly order = ',num2str(n-1)])%%%%%%
grid on

ax2 = subplot(2,1,2);
s2 = scatter(timeVec,spannweiteVec,markersize,'filled','b'); %data points
alpha(s2,transparency)
hold on
plot(timeVecPlot,ppval(ppSpannweite,timeVecPlot),'r','LineWidth',linewidth)
plot(breaks,ppval(ppSpannweite,breaks),'r*')
% plot(timeVecPlot, y_fitSpann,'k')
% plot(timeVecPlot, y_fitSpann+deltaSpann,'r')
% plot(timeVecPlot, y_fitSpann-deltaSpann,'r')
hold off
ylabel('Absolute Return [%]')
xlabel('Zeit [h] UTC') %%%%%%%%%%%%%%%%
grid on

linkaxes([ax1,ax2],'x')
subplot(2,1,1)
axis([0,24,0,yAxMult*max(ppval(ppSpread,timeVecPlot))])
subplot(2,1,2)
axis([0,24,0,yAxMult*max(ppval(ppSpannweite,timeVecPlot))])

end

