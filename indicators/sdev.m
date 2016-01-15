function [sdev] = sdev(DS,i,t)
    sdev = std(DS.ask_close(i-t:i));

end
