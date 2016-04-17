function datacndl(underlying_tx, startpoint, numberbars)
%Plot OHLC Candles
% Author: Nagi Hatoum, Candlestick chart ploter function, 5/29/03
%Source: http://www.mathworks.com/matlabcentral/fileexchange/3549-candlestick-graph/content//cndl.m
%Changed Colors
n= startpoint+numberbars;
O=underlying_tx.ask_open(startpoint:n);
H=underlying_tx.HIGH_ask(startpoint:n);
L=underlying_tx.LOW_ask(startpoint:n);
C=underlying_tx.ask_close(startpoint:n);
med=underlying_tx.MED_ask(startpoint:n);

w=.4; %width of body, change to draw body thicker or thinner
%%%%%%%%%%%Find up and down days%%%%%%%%%%%%%%%%%%%
d=C-O;
l=length(d);
hold on
%%%%%%%%draw line from Low to High%%%%%%%%%%%%%%%%%
for i=1:l
   line([i i],[L(i) H(i)])
end
%%%%%%%%%%draw red body (down day)%%%%%%%%%%%%%%%%%
n=find(d<0);
if ~isempty(n)
   for i=1:length(n)
      x=[n(i)-w n(i)-w n(i)+w n(i)+w n(i)-w];
      y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
      patch(x,y,'r')
   end
   %plot(n,C(n),'rs','MarkerFaceColor','r')
end
%%%%%%%%%%draw GREEN body(up day)%%%%%%%%%%%%%%%%%%%
n=find(d>=0);
if ~isempty(n)
   for i=1:length(n)
      x=[n(i)-w n(i)-w n(i)+w n(i)+w n(i)-w];
      y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
      patch(x,y,'g')
   end
   grid on;
   grid minor;
      %%%Hier müssen wieder die Labels und Titel rein
   %X axis: Date [YYYY-MM-DD HH:mm]
   %Y Axis: Preis
   % title: Underying YYYY-MM-DD HH:mm - YYYY-MM-DD HH:mm OHLC
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

