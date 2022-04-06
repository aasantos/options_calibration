load('callputMar14_18.mat');
%% run estimation of Bates model
tic
[XM,FVALM,EXITFLAGM,OUTPUTM,LAMBDAM,GRADM,HESSIANM] = ...
    calibrationMertonbd(ctable,ptable);
toc
%% save data
save('mertonout.mat','XM','FVALM','EXITFLAGM','OUTPUTM','LAMBDAM','GRADM','HESSIANM');
%%