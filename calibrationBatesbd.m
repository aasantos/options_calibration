function [X,FVAL,EXITFLAG,OUTPUT,LAMBDA,GRAD,HESSIAN] = calibrationBatesbd(calltable,puttable)
    %
    Rate = 0.02;
    NumFFT = 2^12;
    DividendYield = 0;
    %
    [m,~] = size(calltable);
    [n,~] = size(puttable);
    step = 1000;
    miter = floor(m/step);
    niter = floor(n/step);
    call = zeros(m,1);
    put = zeros(n,1);
    %
    function ff = objfunc(x)
        %
        V0 = x(1);
        ThetaV = x(2);
        Kappa = x(3);
        SigmaV = x(4);
        RhoSV = x(5);
        MeanJ = x(6);
        JumpVol = x(7);
        JumpFreq = x(8);
        %
        for i=1:miter
            linf = (i-1)*step + 1;
            lsup = i*step;
            callt = optByBatesFFT(Rate,calltable.stockprice(linf:lsup), ...
                         calltable.settle(linf:lsup), ...
                         calltable.maturity(linf:lsup),'call', ...
                         calltable.strike(linf:lsup),V0,ThetaV,Kappa,SigmaV,RhoSV,MeanJ, ...
                         JumpVol,JumpFreq,'DividendYield',DividendYield, ...
                         'NumFFT',NumFFT,'CharacteristicFcnStep',0.065, ...
                          'LogStrikeStep',0.001,'Basis',1);
            call(linf:lsup) = callt;
        end
        %
        for j=1:niter
            linf = (j-1)*step + 1;
            lsup = j*step;
            putt = optByBatesFFT(Rate,puttable.stockprice(linf:lsup), ...
                         puttable.settle(linf:lsup), ...
                         puttable.maturity(linf:lsup),'put', ...
                         puttable.strike(linf:lsup),V0,ThetaV,Kappa,SigmaV,RhoSV,MeanJ, ...
                         JumpVol,JumpFreq,'DividendYield',DividendYield, ...
                         'NumFFT',NumFFT,'CharacteristicFcnStep',0.065, ...
                          'LogStrikeStep',0.001,'Basis',1);
           put(linf:lsup) = putt;
        end
        %
        linf = miter*step + 1;
        lsup = m;
        callt = optByBatesFFT(Rate,calltable.stockprice(linf:lsup), ...
                         calltable.settle(linf:lsup), ...
                         calltable.maturity(linf:lsup),'call', ...
                         calltable.strike(linf:lsup),V0,ThetaV,Kappa,SigmaV,RhoSV,MeanJ, ...
                         JumpVol,JumpFreq,'DividendYield',DividendYield, ...
                         'NumFFT',NumFFT,'CharacteristicFcnStep',0.065, ...
                          'LogStrikeStep',0.001,'Basis',1);
        call(linf:lsup) = callt;
        %
        linf = niter*step + 1;
        lsup = n;
        putt = optByBatesFFT(Rate,puttable.stockprice(linf:lsup), ... 
                         puttable.settle(linf:lsup), ...
                         puttable.maturity(linf:lsup),'put', ...
                         puttable.strike(linf:lsup),V0,ThetaV,Kappa,SigmaV,RhoSV,MeanJ, ...
                         JumpVol,JumpFreq,'DividendYield',DividendYield, ...
                         'NumFFT',NumFFT,'CharacteristicFcnStep',0.065, ...
                          'LogStrikeStep',0.001,'Basis',1);
        put(linf:lsup) = putt;
        %                          
       ff = sum(abs((call - calltable.price)./calltable.price)) + ...
            sum(abs((put - puttable.price)./puttable.price));
            
    end
    %
    function [c,ceq] = nlc(x)
       c = x(4)*x(4) - 2*x(2)*x(3);
       ceq = [];
    end
    %    
    %
    lb = [0.01    0.01  0.2    0.01  -1  -1  0.01   0.1];
    ub = [2.0     2.0   50.0   2.0    0   1  1.0   20.0];
    %
    %
    options = optimoptions('fmincon','Display','iter', ...
                            'MaxFunctionEvaluations',10000, ...
                            'Algorithm','interior-point');
    %
    x0 = [0.0212 0.0412 3.4268 0.1032 -0.4353 -0.34 0.08 1.7];
    [X,FVAL,EXITFLAG,OUTPUT,LAMBDA,GRAD,HESSIAN] = fmincon(@objfunc,x0, ...
                                    [],[],[],[],lb,ub,@nlc,options);
    %
end