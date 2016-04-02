function [] = plotverlauf( data,underlying,percentage )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    dt = mode(diff(data.time(:,4)*60+data.time(:,5)));

    startDate = datenum(data.time(1,1),data.time(1,2),data.time(1,3),data.time(1,4),data.time(1,5),0);
    endDate = datenum(data.time(end,1),data.time(end,2),data.time(end,3),data.time(end,4),data.time(end,5),0);
    dateVec = linspace(startDate,endDate,size(data,1));
    
    verlaufData =   data.ask_open;
    returnData =    ((data.ask_close-data.ask_open)./data.ask_open)*100;
    
    N = length(data.time(:,1));
    if percentage <= 0
        ind_out = [];
        ind_in = 1:N;
    elseif percentage>0 && percentage<1
        indexChange = floor((1-percentage)*N);
        ind_out = indexChange+1:N;
        ind_in = 1:indexChange;
    else %percentage >= 0
        ind_out = 1:N;
        ind_in = [];
    end
    
    scrsz = get(groot,'ScreenSize');
    figure('Position',[1 scrsz(4)/2 1920/2 1080/2])
    
    XTick = [1,size(data,1)];
    XTickLabel = {[num2str(data.time(1,3)),'.',num2str(data.time(1,2)),'.',num2str(data.time(1,1))],...
	[num2str(data.time(end,3)),'.',num2str(data.time(end,2)),'.',num2str(data.time(end,1))]};
    
    ax1 = subplot(2,1,1);
    plot(dateVec(ind_in),verlaufData(ind_in),'k')
    hold on
    grid on
    grid minor
    plot(dateVec(ind_out),verlaufData(ind_out),'r--')
    hold off
    legObj1 = legend('in sample','out of sample','Location','NorthEast');
    set(legObj1,'FontSize',10);
    legend('boxoff')
    title([underlying,', Zeitintervall: ',num2str(dt),' min'])
%     legend('in sample','out of sample','Location','eastoutside')
    ylabel('Preis')
    ax1.XTickLabel = {};
%     sizeFig = get(gcf,'Position');
    %%
    ax2 = subplot(2,1,2);
    bar(dateVec(ind_in),returnData(ind_in),'k')
    hold on
    grid on
    grid minor
    bar(dateVec(ind_out),returnData(ind_out),'FaceColor','r','EdgeColor','r')
    hold off
    datetick(ax2,'x','dd-mm-yy','keepticks')
    legObj2 = legend('in sample','out of sample','Location','NorthEast');
    set(legObj2,'FontSize',10);
    legend('boxoff')
    ax2.XTickLabelRotation = 45;
    ylabel('Return [%]')
%     set(gcf,'Position',sizeFig);
    
   
%     axis([-inf ax2.XLim(2)+0.3*diff(ax2.XLim) -inf inf])
    
%     ax2.XTickMode = 'manual';
%     ax2.YTickMode = 'manual';
%     ax2.ZTickMode = 'manual';
%     ax2.XLimMode = 'manual';
%     ax2.YLimMode = 'manual';
%     ax2.ZLimMode = 'manual';
%     
% 	ax1.XTickMode = 'manual';
%     ax1.YTickMode = 'manual';
%     ax1.ZTickMode = 'manual';
%     ax1.XLimMode = 'manual';
%     ax1.YLimMode = 'manual';
%     ax1.ZLimMode = 'manual';

    linkaxes([ax1,ax2],'x')
end

