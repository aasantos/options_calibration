load('callputMar14_18.mat');
%% run estimation of Bates model
tic
[XH,FVALH,EXITFLAGH,OUTPUTH,LAMBDAH,GRADH,HESSIANH] = ...
    calibrationHestonbd(ctable,ptable);
toc
%% save data
save('hestonout.mat','XH','FVALH','EXITFLAGH','OUTPUTH','LAMBDAH','GRADH','HESSIANH');
%