function [sdev] = sdev(DS,i,t)
% calculating standard deviation from past t intervalls
sdev = std(DS.ask_close(i-t:i));

end
