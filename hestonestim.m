load('callputMar14_18.mat');
%% run estimation of Bates model
[XH,FVALH,EXITFLAGH,OUTPUTH,LAMBDAH,GRADH,HESSIANH] = ...
    calibrationHestonbd(ctable,ptable);
%% save data
save('hestonout.mat','XH','FVALH','EXITFLAGH','OUTPUTH','LAMBDAH','GRADH','HESSIANH');
%