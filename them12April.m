clc
clear

tic
load 'MCS_MY33_surf.mat'
C=[];
datapro=nan(length(test),21);
for i=1:length(test)
    disp(['LoopOrder',num2str(i)])
    g=test{i,1};
    g2=str2double(string(g));
    g2(g2==-9999)=nan;
    C = nanmean(g2,1);

    datapro(i,:)=C;

end

toc