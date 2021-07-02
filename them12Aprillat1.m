clc
clear

tic


D=dir('MY*.xlsx');
for i=1:length(D)
    input=D(i).name;
    
    [~, ~, raw] = xlsread(input,'Sheet1','A2:E20000');
    data = reshape([raw{:}],size(raw));
    
    sol=data(:,1);
    lat= data(:,2);
    lon= data(:,3);
    lt= data(:,4);
    Atemp= data(:,5);
    
    % Clear temporary variables
    clearvars data raw;
    
    ls_bin=0:2:360;
    lat_bin=-90:2:90;
    
    thmtemp=NaN(length(ls_bin)-1,length(lat_bin)-1);
    for k=1:length(ls_bin)-1
        for i=1:length(lat_bin)-1
            temp1=Atemp;
            temp2=temp1(sol>=ls_bin(k) & sol<ls_bin(k+1)...
                & lat>=lat_bin(i) & lat<lat_bin(i+1));
            
            thmtemp(k,i)=nanmean(temp2);
        end
    end
    clearvars data temp2 temp1 data p
    A1=thmtemp;   
    fname=[("Temp_Plot_new2021_2lat_2Ls_")+string(input)];
    xlswrite(fname,'Temp','Sheet1','A1');
    xlswrite(fname,lat_bin,'Sheet1','B2');
    xlswrite(fname,ls_bin','Sheet1','A3');
    xlswrite(fname,A1,'Sheet1','B3');
    
    clearvars  fname
end







toc