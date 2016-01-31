function [ ] = plot_cumret_dens_invsout(insamplereturnvec, outsamplereturnvec)
%Plots comparing in vs out of sample (cumulativ returns and distributions of returns)
%Inputs
%insamplereturnvec..... intraday trades returns in sample,
%outsamplereturnvec.... intraday trades returns out of sample

%%Generating compounded returns

    m = length(insamplereturnvec);
    n = length(outsamplereturnvec);

           %%%%%%%%%%%%%%%%%%%
    crin = zeros(m,1);% In Sample coumpounded return vector
    crout= zeros(n,1);% Ou of Sample compounded return vector
    lcrin=ones(m,1); %for log scaling Chart
    lcrout=ones(n,1);
    % in sample
    crin(1)= insamplereturnvec(1);
    for i= 2:m
        crin(i)=(crin(i-1)+1)*(1+insamplereturnvec(i))-1;
    end

    % out of sample
    crout(1)= outsamplereturnvec(1);
    for j= 2:n
        crout(j)=(crout(j-1)+1)*(1+outsamplereturnvec(j))-1;
    end
    
    % in sample log
        lcrin(1)= 1+insamplereturnvec(1);
    for i= 2:m
        lcrin(i)=(lcrin(i-1))*(1+insamplereturnvec(i));
    end
   
    lcrin=log(lcrin);
    
      % out sample log
        lcrout(1)= 1+outsamplereturnvec(1);
    for j= 2:n
        lcrout(j)=(lcrout(j-1))*(1+outsamplereturnvec(j));
    end
   
    lcrout=log(lcrout);
    
    
    %Returns in percent
    crin=crin*100;
    crout=crout*100;
    insamplereturnvec=100*insamplereturnvec;
    outsamplereturnvec=100*outsamplereturnvec;
      %Returns in percent
    crin=crin*100;
    crout=crout*100;
    insamplereturnvec=100*insamplereturnvec;
    outsamplereturnvec=100*outsamplereturnvec;

%%Kernel estimates for the returns (%)
    %Estimates
    [x,xi] = ksdensity(insamplereturnvec);
    [y,xo] = ksdensity(outsamplereturnvec);

    %median return
    mi= median(insamplereturnvec);
    mo= median(outsamplereturnvec);

%%%%%Plotting

    %%parameters for Scaling Axis
    inmax=max(x)*1.05;
    outmax=max(y)*1.05;
    kaxmax(1)= inmax;
    kaxmax(2)= outmax;
    xmax= max(kaxmax)*1.02;
    
%Logarithmic
    figure
    %%%%Cumulated return lines
    subplot(2,2,[1,2]);
        %logaritmic plotting
        plot(lcrin,'b-.','LineWidth',1.5);
        hold on;
        plot(lcrout,'r' ,'LineWidth',1.5);
        grid on;
        c_legend=legend('In Sample','Out of Sample','Location','northwest');
        set(c_legend,'FontSize', 8);
        t=title('Kumulativer Return');
        set(t,'FontSize', 12)
        %legend('boxoff')
        xlabel('Anzahl Trades')
        ylabel('ln(Kumulativer Return))')
        hold off; 

    % Kernel Plot In Sample and out of Sample Comparison in on subplot

    subplot(2,2,[3,4]);
    plot(xi,x, 'b-.','LineWidth',1.5);
    t=title('Kerneldichteschätzung');
    set(t,'FontSize', 12);
    hold on;
    line([mi mi], [0.0 inmax],'Color','b', 'LineStyle','-.','LineWidth',1)
    xlabel('Return (%)')
    ylabel('Dichte')
    %Out of Sample overlay
    plot(xo,y, 'r','LineWidth',1.5);
    hold on;
    line([mo mo], [0.0 outmax],'Color','r', 'LineStyle','-','LineWidth',1)
    axis([-inf inf 0 xmax])
    k_legend=legend('In Sample','Median In Sample','Out of Sample','Median Out of Sample','Location','northwest');
    set(k_legend,'FontSize', 8);
    %legend('boxoff')
    xlabel('Return (%)')
    ylabel('Dichte')
    grid on;
    grid on;
    hold off;
    

    
    %Saving plots
    saveas(gcf,'./plots/logInVSoutPlot_cumret_dens','epsc') %EPS for latex
    saveas(gcf,'./plots/logInVSoutPlot_cumret_dens','png') %PNG normal
    close;
    
    
    
%Linear plot    
        figure
    %%%%Cumulated return lines
    subplot(2,2,[1,2]);
%     %Linear Plotting
        plot(crin,'b-.','LineWidth',1.5);
        hold on;
        plot(crout,'r' ,'LineWidth',1.5);
        grid on;
        c_legend=legend('In Sample','Out of Sample','Location','northwest');
        set(c_legend,'FontSize', 8);
        t=title('Kumulativer Return');
        set(t,'FontSize', 12)
        %legend('boxoff')
        xlabel('Anzahl Trades')
        ylabel('Kumulativer Return (%)')
        hold off; 


    % Kernel Plot In Sample and out of Sample Comparison in on subplot

    subplot(2,2,[3,4]);
    plot(xi,x, 'b-.','LineWidth',1.5);
    t=title('Kerneldichteschätzung');
    set(t,'FontSize', 12);
    hold on;
    line([mi mi], [0.0 inmax],'Color','b', 'LineStyle','-.','LineWidth',1)
    xlabel('Return (%)')
    ylabel('Dichte')
    %Out of Sample overlay
    plot(xo,y, 'r','LineWidth',1.5);
    hold on;
    line([mo mo], [0.0 outmax],'Color','r', 'LineStyle','-','LineWidth',1)
    axis([-inf inf 0 xmax])
    k_legend=legend('In Sample','Median In Sample','Out of Sample','Median Out of Sample','Location','northwest');
    set(k_legend,'FontSize', 8);
    %legend('boxoff')
    xlabel('Return (%)')
    ylabel('Dichte')
    grid on;
    grid on;
    hold off;
   

    
    %Saving plots
    saveas(gcf,'./plots/linInVSoutPlot_cumret_dens','epsc') %EPS for latex
    saveas(gcf,'./plots/linInVSoutPlot_cumret_dens','png') %PNG normal
    close;