%%
load('callputMar14_18.mat');
%% run estimation of Bates model
tic
[XB,FVALB,EXITFLAGB,OUTPUTB,LAMBDAB,GRADB,HESSIANB] = ...
    calibrationBatesbd(ctable,ptable);
toc
%% save data
save('batesout.mat','XB','FVALB','EXITFLAGB','OUTPUTB','LAMBDAB','GRADB','HESSIANB');
%%