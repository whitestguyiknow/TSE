function datacndlmed(underlying_tx, startpoint, numberbars, medianOn)
%Plot OHLC Candles and adding the tick Based Median
% Author Of OHLC: Nagi Hatoum, Candlestick chart ploter function, 5/29/0

%Source: http://www.mathworks.com/matlabcentral/fileexchange/3549-candlestick-graph/content//cndl.m
%Changed Colors
%Added yellow star median and adapted datastructure

n= startpoint+numberbars-1;
O=underlying_tx.ask_open(startpoint:n);
H=underlying_tx.HIGH_ask(startpoint:n);
L=underlying_tx.LOW_ask(startpoint:n);
C=underlying_tx.ask_close(startpoint:n);
med=underlying_tx.MED_ask(startpoint:n);
%%
timeVec = datenum(underlying_tx.time(startpoint:n,:));
%%
w=.02; %width of body, change to draw body thicker or thinner
%%Find up and down days
d=C-O;
l=length(d);
hold on
%draw line from Low to High
for i=1:l
   line([timeVec(i) timeVec(i)],[L(i) H(i)])
end
%%draw red body (down day)%
n=find(d<0);
if ~isempty(n)
   for i=1:length(n)
%       x=[n(i)-w n(i)-w n(i)+w n(i)+w n(i)-w];
        x=[timeVec(n(i))-w timeVec(n(i))-w timeVec(n(i))+w timeVec(n(i))+w timeVec(n(i))-w];
        y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
        patchObjRed = patch(x,y,'r');
        set(patchObjRed,'EdgeColor','r')
   end
   %plot(n,C(n),'rs','MarkerFaceColor','r')
end
%draw green body(up day)
n=find(d>=0);
if ~isempty(n)
   for i=1:length(n)
%         x=[n(i)-w n(i)-w n(i)+w n(i)+w n(i)-w];
        x=[timeVec(n(i))-w timeVec(n(i))-w timeVec(n(i))+w timeVec(n(i))+w timeVec(n(i))-w];
        y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
        patchObjGreen = patch(x,y,'g');
        set(patchObjGreen,'EdgeColor','g')
   end
   if medianOn
       %Plot Median
        
        for i=1:l
            medPlot = plot(timeVec(i),med(i),'b*');
            set(medPlot,'MarkerSize',3)
        end
        
        
   end
   grid on;
   grid minor
   
   datetick('x','dd-mm-yy','keeplimits')
   
   %%%Hier müssen wieder die Labels und Titel rein
   %X axis: Date [YYYY-MM-DD HH:mm]
   %Y Axis: Preis
   % title: Underying YYYY-MM-DD HH:mm - YYYY-MM-DD HH:mm OHLC-Median
end
