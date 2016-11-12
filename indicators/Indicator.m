classdef Indicator
    % Class to hook up indicators 
    %   Detailed explanation goes here
    
    properties (Dependent)
        control = 0
        buyPrice = nan
        sellPrice = nan
        sdev_trailing_low = 0
        sdev_trailing_high = inf
        entryBuyFunc
        entrySellFunc
        exitBuyFunc
        exitSellFunc
    end
    
    methods
        function TF = entryBuy(dat1,i1,dat2,i2,varargin)
            TF = feval(entryBuyFunc,dat1,i1,dat2,i2,varargin);
        end
        function TF = entrySell(dat1,i1,dat2,i2,varargin)
            TF = feval(entrySellFunc,dat1,i1,dat2,i2,varargin);
        end
        
    end
    
end

