clc
clear

tic
load 'MCS_MY35_200pas.mat'
C=[];
datapro=nan(length(test),21);
for i=1:length(test)
    disp(['LoopOrder',num2str(i)])
    g=test{i,1};
    g2=str2double(string(g));
    C = nanmean(g2,1);

    datapro(i,:)=C;

end

toc