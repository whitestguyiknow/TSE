%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Example Plots

clear all
%%%%%% Based on Asset
EURUSD = load('./dat/EURUSDplot.mat');
    EURUSD_pre = EURUSD.EURUSD_pre;
    EURUSD_t1 = EURUSD.EURUSD_t1;
    EURUSD_t2 = EURUSD.EURUSD_t2;
    
%%%%%% Asset manipulation
n=100;
O=EURUSD_t2.ask_open(1:n);
H=EURUSD_t2.HIGH_ask(1:n);
L=EURUSD_t2.LOW_ask(1:n);
C=EURUSD_t2.ask_close(1:n);
med=EURUSD_t2.MED_ask(1:n);

%%%%%%%%%%%%%%%%%%% CANDLESTICK NORMAL + MEDIAN********
%%%%%%%Normal Candlestick Plot
subplot(2,1,1);
datacndl(H,L,C,O)
t=title('Normal Candlestick (OHLC Data)');
set(t,'FontSize', 12);
xlabel('250 min Candles')
ylabel('EURUSD')
hold off;

%%%%Candle Stick with MEDIAN Whoop Whooop! Idea using as Turningpoint Indication.... 
subplot(2,1,2);
datacndlmed(H,L,C,O,med)
t=title('Candlestick In Candle Tick based Median (OHLC+Median Data)');
set(t,'FontSize', 12);
xlabel('250 min Candles')
ylabel('EURUSD')
hold off;
saveas(gcf,'./plots/ExampleCandlestickwithmedian','epsc') %EPS for latex
saveas(gcf,'./plots/ExampleCandlestickwithmedian','png') %PNG normal
close;

%%%%%%%%%%%%%%%%%%%%%%%%Plotting in vs Out Of sample Systems
%%Simulation with normally dist

xxx=normrnd(0.006,0.04, 1200,1);
yyy=normrnd(0.004,0.05, 900,1);

insamplereturnvec=xxx;
outsamplereturnvec=yyy;

plot_cumret_dens_invsout(insamplereturnvec, outsamplereturnvec)


%%%%%%%Plot of Spread By Day time
%%Simulating plot


v=[1:300];
time=kron(ones(1,4),v);

sh=normrnd(0.05,0.03, 150,1);
sl=normrnd(0.007,0.03, 150,1);
dl(1:150)=sh;
dl(151:300)=sl;
spread=kron(ones(1,4),dl);
x=time;
y=spread;

%%%%% Polynomial Regression for Fitting

[p,s] = polyfit(x, y, 5);
[y_fit, delta] = polyval(p, x, s);

plot(x,y,'k.')
hold on
plot(x,polyval(p,x),'r--', 'LineWidth',2)
plot(x, y_fit + 2 * delta, 'b:', x, y_fit - 2 * delta, 'b:')
saveas(gcf,'./plots/ExampleforSpread','epsc') %EPS for latex
saveas(gcf,'./plots/ExampleforSpread','png') %PNG normal
close

